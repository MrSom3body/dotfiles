{
  pkgs,
  settings,
  ...
}: let
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  programs.firefox = {
    enable = true;
    package =
      if settings.programs.browser == "firefox-beta"
      then pkgs.firefox-beta
      else pkgs.firefox;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        force = true;
        default = "DuckDuckGo";
        engines = {
          "Startpage" = {
            urls = [{template = "https://www.startpage.com/do/search?query={searchTerms}";}];
            iconUpdateURL = "https://www.startpage.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["!sp"];
          };
          "ProtonDB" = {
            urls = [{template = "https://protondb.com/search?q={searchTerms}";}];
            icon = "https://protondb.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["!pdb"];
          };
          "GitHub" = {
            urls = [{template = "https://github.com/search?q={searchTerms}";}];
            iconUpdateURL = "https://github.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["!gh"];
          };
          "Alternativeto.net" = {
            urls = [{template = "https://alternativeto.net/browse/search/?q={searchTerms}";}];
            iconUpdateURL = "https://alternativeto.net/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["!alt"];
          };
          "YouTube" = {
            urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
            iconUpdateURL = "https://www.youtube.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["!yt"];
          };
          "MyNixOS" = {
            urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["!no"];
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
            definedAliases = ["!np"];
          };
        };
      };
    };

    policies = {
      AutofillCreditCardEnabled = false;
      DisablePocket = true;
      DisplayBookmarksToolbar = "newtab";
      DisplayMenuBar = "default-off";
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      FirefoxHome = {
        Search = true;
        TopSites = true;
        Highlights = true;
        Pocket = false;
        Snippets = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = true;
        Locked = true;
      };
      HardwareAcceleration = true;
      Homepage = {
        StartPage = "homepage";
      };
      HttpsOnlyMode = "force_enabled";
      NewTabPage = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      SearchBar = "unified";
      SearchSuggestEnabled = true;
      TranslateEnabled = true;

      # about:config
      Preferences = {
        "browser.ctrlTab.sortByRecentlyUsed" = lock-true;
        "browser.tabs.hoverPreview.enabled" = lock-true;
        "browser.tabs.inTitlebar" = {
          Value = 0;
          Status = "locked";
        };
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = lock-true;
        "sidebar.revamp" = lock-true;
        "sidebar.verticalTabs" = lock-true;
      };
    };
  };
}
