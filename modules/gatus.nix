{ config, lib, ... }:
let
  inherit (config.flake) meta;

  mkServiceEndpoints =
    services:
    lib.mapAttrsToList (
      name: srv:
      let
        statusCodes = [ 200 ] ++ (srv.alt-status-codes or [ ]);
        statusCondition = builtins.concatStringsSep " || " (
          map (c: "[STATUS] == ${toString c}") statusCodes
        );
      in
      {
        inherit name;
        url = "https://${srv.domain}";
        interval = "5m";
        conditions = [
          statusCondition
          "[RESPONSE_TIME] < 500"
        ];
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
          endpoints = [
            {
              name = "website";
              url = "https://karun.sndh.dev";
              interval = "5m";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 300"
              ];
            }
          ]
          ++ mkServiceEndpoints (config.flake.lib.getRunningServices config.flake);
        };
      };
    };
  };
}
