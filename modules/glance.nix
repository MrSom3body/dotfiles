{ config, lib, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.glance =
    { config, ... }:
    {
      config = {
        services = {
          caddy.virtualHosts."${meta.services.glance.domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${toString meta.services.glance.port}
              import cloudflare
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
                  name = "Startpage";
                  hide-desktop-navigation = false;
                  center-vertically = true;
                  width = "slim";
                  columns = [
                    {
                      size = "small";
                      widgets = [
                        {
                          type = "clock";
                          hour-format = "24h";
                          timezones = [
                            {
                              timezone = "Asia/Kolkata";
                              label = "Kolkata";
                            }
                            {
                              timezone = "America/New_York";
                              label = "New York";
                            }
                          ];
                        }
                        {
                          type = "weather";
                          untis = "metric";
                          hour-format = "24h";
                          location = "Vienna, Austria";
                        }
                      ];
                    }
                    {
                      size = "full";
                      widgets = lib.singleton {
                        type = "bookmarks";
                        groups = [
                          {
                            title = "general";
                            links = [
                              {
                                title = "mail";
                                url = "https://mail.proton.me";
                              }
                              {
                                title = "calendar";
                                url = "https://calendar.proton.me";
                              }
                              {
                                title = "drive";
                                url = "https://drive.proton.me";
                              }
                            ];
                          }
                          {
                            title = "management";
                            links = [
                              {
                                title = "cloudflare";
                                url = "https://dash.cloudflare.com";
                              }
                              {
                                title = "nextdns";
                                url = "https://my.nextdns.io";
                              }
                              {
                                title = "tailscale";
                                url = "https://login.tailscale.com";
                              }
                            ];
                          }
                          {
                            title = "entertainment";
                            links = [
                              {
                                title = "netflix";
                                url = "https://netflix.com";
                              }
                              {
                                title = "prime video";
                                url = "https://primevideo.com";
                              }
                              {
                                title = "youtube";
                                url = "https://youtube.com";
                              }
                            ];
                          }
                          {
                            title = "socials";
                            links = [
                              {
                                title = "instagram";
                                url = "https://instagram.com";
                              }
                              {
                                title = "mastodon";
                                url = "https://mastodon.social";
                              }
                              {
                                title = "reddit";
                                url = "https://reddit.com";
                              }
                            ];
                          }
                        ];
                      };
                    }

                  ];
                }

                {
                  name = "Homelab";
                  hide-desktop-navigation = false;
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
                          allServices = meta.services;
                          servicesToShow = lib.filterAttrs (
                            _name: service: (service.show or false) && (service ? "domain")
                          ) allServices;
                          formattedServices = lib.mapAttrsToList (
                            name: service:
                            {
                              title = name;
                              url = "https://" + service.domain;
                            }
                            // lib.optionalAttrs (service ? "icon") { inherit (service) icon; }
                            // lib.optionalAttrs (service ? "alt-status-codes") {
                              "alt-status-codes" = service."alt-status-codes";
                            }
                          ) servicesToShow;
                        in
                        [
                          {
                            type = "monitor";
                            cache = "15s";
                            title = "Services";
                            sites = formattedServices;
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
