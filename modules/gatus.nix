{ config, lib, ... }:
let
  inherit (config.flake) meta;

  mkServiceEndpoints =
    services:
    lib.mapAttrsToList (
      name: srv:
      let
        statusCodes = [ 200 ] ++ srv.alt-status-codes;
        statusCondition =
          if builtins.length srv.alt-status-codes == 0 then
            "[STATUS] == 200"
          else
            "[STATUS] == any(${builtins.concatStringsSep ", " (map toString statusCodes)})";

        defaultGatusConditions = [
          statusCondition
          "[RESPONSE_TIME] < 500"
        ];
      in
      {
        inherit name;
        inherit (srv) url group;
        interval = "5m";
        conditions =
          if srv.gatus.defaultConditions then
            defaultGatusConditions ++ srv.gatus.conditions
          else
            srv.gatus.conditions;
      }
    ) services;
in
{
  flake.modules.nixos.gatus = {
    services = {
      caddy.virtualHosts."${meta.services.gatus.domain}" = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString meta.services.gatus.port}
        '';
      };

      gatus = {
        enable = true;
        settings = {
          web.port = meta.services.gatus.port;
          ui = {
            title = "status | som3lab";
            header = "som3lab's uptime";
            link = meta.services.gatus.url;
            default-sort-by = "group";
          };
          endpoints = mkServiceEndpoints (config.flake.lib.getRunningServices config.flake);
        };
      };
    };
  };
}
