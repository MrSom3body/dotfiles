{ config, lib, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
in
{
  flake.modules.nixos.glance = { config, ... }: {
    config = {
      services = {
        caddy.virtualHosts."${meta.services.glance.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.glance.port}
          '';
        };

        glance = {
          enable = true;
          settings = {
            server = {
              host = "127.0.0.1";
              inherit (meta.services.glance) port;
            };

            pages = [
              {
                name = "Karun's Homelab";
                hide-desktop-navigation = true;
                center-vertically = true;
                width = "slim";
                columns = [
                  {
                    size = "small";
                    widgets = [
                      {
                        type = "server-stats";
                        servers = lib.singleton {
                          type = "local";
                          name = config.networking.hostName;
                        };
                      }
                      {
                        type = "repository";
                        repository = "MrSom3body/dotfiles";
                        pull-requests-limit = 5;
                        issues-limit = 5;
                        commits-limit = 5;
                      }
                    ];
                  }
                  {
                    size = "full";
                    widgets =
                      let
                        allServices =
                          flake.lib.getRunningServices flake |> lib.filterAttrs (_name: service: service.show or false);
                        privateServices = allServices |> lib.filterAttrs (_name: service: (!service.public or false));
                        publicServices = allServices |> lib.filterAttrs (_name: service: (service.public or false));
                        formatServices =
                          services:
                          services
                          |> lib.mapAttrsToList (
                            name: service:
                            {
                              title = name;
                              url = "https://" + service.domain;
                            }
                            // lib.optionalAttrs (service ? "icon") { inherit (service) icon; }
                            // lib.optionalAttrs (service ? "alt-status-codes") {
                              "alt-status-codes" = service."alt-status-codes";
                            }
                          );
                      in
                      [
                        {
                          type = "monitor";
                          cache = "15s";
                          title = "Public Services";
                          sites = formatServices publicServices;
                        }
                        {
                          type = "monitor";
                          cache = "15s";
                          title = "Private Services";
                          sites = formatServices privateServices;
                        }
                      ];
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };
}
