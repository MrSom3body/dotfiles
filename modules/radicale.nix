{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.radicale =
    { config, ... }:
    {
      sops.secrets = {
        radicale-htpasswd = {
          sopsFile = ../secrets/radicale.yaml;
          owner = "radicale";
          group = "radicale";
        };
      };

      services = {
        radicale = {
          enable = true;
          settings = {
            server.hosts = [ "127.0.0.1:${toString meta.services.radicale.port}" ];
            auth = {
              type = "htpasswd";
              # htpasswd -5 -c /dev/stdout <mail>
              htpasswd_filename = config.sops.secrets.radicale-htpasswd.path;
              htpasswd_encryption = "autodetect";
            };
            storage = {
              filesystem_folder = "/var/lib/radicale/collections";
            };
          };
        };

        caddy.virtualHosts = {
          ${meta.services.radicale.domain} = {
            extraConfig = ''
              reverse_proxy http://localhost:${toString meta.services.radicale.port}
            '';
          };
        };
      };
    };
}
