{config, ...}: let
  cfg = config.services.glance;
in {
  services = {
    caddy.virtualHosts."home.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://${cfg.settings.server.host}:${toString cfg.settings.server.port}
        import cloudflare
      '';
    };

    glance = {
      enable = true;
      settings = {
        server = {
          host = "0.0.0.0";
          port = 8080;
        };

        pages = [
          {
            name = "Startpage";
            hide-desktop-navigation = true;
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
                widgets = [
                  {
                    type = "monitor";
                    cache = "1m";
                    title = "Services";
                    style = "compact";
                    sites = let
                      mkSite = title: url: {
                        inherit title;
                        inherit url;
                      };
                    in [
                      (mkSite "loxone" "https://loxone.sndh.dev")
                      (mkSite "immich" "https://immich.sndh.dev")
                      (mkSite "ddns updater" "https://ddns.sndh.dev")
                      (mkSite "firefox send" "https://send.sndh.dev")
                    ];
                  }
                  {
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
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
