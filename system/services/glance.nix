{
  config,
  lib,
  ...
}: {
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 8080;
      };

      # copied from https://github.com/danth/stylix/blob/d9df91c55643a8b5229a3ae3a496a30f14965457/modules/glance/hm.nix
      theme = let
        rgb-to-hsl = color: let
          r = ((lib.toInt config.lib.stylix.colors."${color}-rgb-r") * 100.0) / 255;
          g = ((lib.toInt config.lib.stylix.colors."${color}-rgb-g") * 100.0) / 255;
          b = ((lib.toInt config.lib.stylix.colors."${color}-rgb-b") * 100.0) / 255;
          max = lib.max r (lib.max g b);
          min = lib.min r (lib.min g b);
          delta = max - min;
          fmod = base: int: base - (int * builtins.floor (base / int));
          h =
            if delta == 0
            then 0
            else if max == r
            then 60 * (fmod ((g - b) / delta) 6)
            else if max == g
            then 60 * (((b - r) / delta) + 2)
            else if max == b
            then 60 * (((r - g) / delta) + 4)
            else 0;
          l = (max + min) / 2;
          s =
            if delta == 0
            then 0
            else 100 * delta / (100 - lib.max (2 * l - 100) (100 - (2 * l)));
          roundToString = value: toString (builtins.floor (value + 0.5));
        in
          lib.concatMapStringsSep " " roundToString [
            h
            s
            l
          ];
      in {
        light = config.stylix.polarity == "light";
        contrast-multiplier = 1.0;
        background-color = rgb-to-hsl "base00";
        primary-color = rgb-to-hsl "base05";
        positive-color = rgb-to-hsl "base0B";
        negative-color = rgb-to-hsl "base08";
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
                    (mkSite "jellyfin" "https://jellyfin.sndh.dev")
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
}
