{ lib, ... }@flakeArgs:
let
  flakeConfig = flakeArgs.config;
  inherit (flakeConfig.flake) meta;

  mkServiceEndpoints =
    services:
    lib.mapAttrsToList (
      _name: srv:
      let
        statusCodes = [ 200 ] ++ srv.alt-status-codes;
        statusCondition =
          if builtins.length srv.alt-status-codes == 0 then
            "[STATUS] == 200"
          else
            "[STATUS] == any(${builtins.concatStringsSep ", " (map toString statusCodes)})";

        defaultGatusConditions = [ statusCondition ];
      in
      {
        name = srv.title;
        inherit (srv) url group;
        interval = "1m";
        conditions =
          if srv.gatus.defaultConditions then
            defaultGatusConditions ++ srv.gatus.conditions
          else
            srv.gatus.conditions;
        alerts = [ { type = "ntfy"; } ];
      }
    ) services;
in
{
  flake.modules.nixos.gatus =
    { config, ... }:
    let
      inherit (config.networking) hostName;
      anubisCfg = config.services.anubis.instances.gatus.settings;
    in
    {
      sops.secrets.gatus = {
        sopsFile = ../secrets/${hostName}/gatus.env;
        format = "dotenv";
      };

      services = {
        anubis.instances.gatus.settings.TARGET = "http://localhost:${toString meta.services.gatus.port}";

        cloudflared.tunnels.${config.networking.hostName}.ingress."${meta.services.gatus.domain}" =
          "unix:${anubisCfg.BIND}";

        caddy.virtualHosts."${meta.services.gatus.domain}" = {
          extraConfig = ''
            reverse_proxy unix/${anubisCfg.BIND}
            tls internal
          '';
        };

        gatus = {
          enable = true;
          environmentFile = config.sops.secrets.gatus.path;
          settings = {
            web.port = meta.services.gatus.port;
            ui = {
              title = "status | som3lab";
              header = "som3lab's uptime";
              link = meta.services.gatus.url;
              default-sort-by = "group";
            };
            storage = {
              path = "/var/lib/gatus/data.db";
              type = "sqlite";
              caching = true;
            };
            endpoints = mkServiceEndpoints (flakeConfig.flake.lib.getRunningServices flakeConfig.flake);
            external-endpoints =
              lib.mapAttrsToList
                (name: _conf: {
                  inherit name;
                  group = "backups";
                  token = "\${BORGMATIC_GATUS_TOKEN}";
                  heartbeat.interval = "48h";
                  alerts = [ { type = "ntfy"; } ];
                })
                (
                  lib.filterAttrs (
                    _name: conf: conf.config.services.borgmatic.enable or false
                  ) flakeConfig.flake.nixosConfigurations
                );
            alerting.ntfy = {
              topic = "alerts";
              url = meta.services.ntfy.url;
              token = "$NTFY_TOKEN";
              click = meta.services.gatus.url;
              priority = 4;
              default-alert = {
                send-on-resolved = true;
                failure-threshold = 6;
              };
            };
          };
        };
      };
    };
}
