{
  pkgs,
  settings,
  ...
}: {
  programs.firefox = {
    enable = true;
    package =
      if settings.programs.browser == "firefox-beta"
      then pkgs.firefox-beta-bin
      else pkgs.firefox-bin;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;
        "cookiebanners.ui.desktop.enabled" = 2;
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
        "network.trr.mode" = 2;
        "network.trr.uri" = "https://dns.quad9.net/dns-query";
        "sidebar.verticalTabs" = true;
      };

      search = {
        force = true;
        default = "DuckDuckGo";
        engines = {
          "ProtonDB" = {
            urls = [{template = "https://protondb.com/search?q={searchTerms}";}];
            icon = "https://protondb.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@pdb"];
          };
          "GitHub" = {
            urls = [{template = "https://github.com/search?q={searchTerms}";}];
            iconUpdateURL = "https://github.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@gh"];
          };
          "Alternativeto.net" = {
            urls = [{template = "https://alternativeto.net/browse/search/?q={searchTerms}";}];
            iconUpdateURL = "https://alternativeto.net/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@alt"];
          };
          "YouTube" = {
            urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
            iconUpdateURL = "https://www.youtube.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@yt"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
            iconUpdateURL = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@nw"];
          };
          "MyNixOS" = {
            urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "Subreddit" = {
            urls = [{template = "https://reddit.com/r/{searchTerms}";}];
            iconUpdateURL = "https://reddit.com/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["r/"];
          };
        };
      };
    };
  };
}
