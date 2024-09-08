{
  pkgs,
  dotfiles,
  ...
}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  programs.firefox = {
    enable = true;
    package =
      if dotfiles.browser == "firefox-beta"
      then pkgs.firefox-beta
      else pkgs.firefox;
    profiles.${dotfiles.username} = {
      id = 0;
      name = dotfiles.username;
      isDefault = true;
      search = {
        force = true;
        default = "DuckDuckGo";
        engines = {
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
      Cookies = {
        Allow = [
          "https://aniwave.to"
          "https://chatgpt.com"
          "https://github.com"
          "https://monkeytype.com"
          "https://netflix.com"
          "https://proton.me"
          "https://web.whatsapp.com"
          "https://www.instagram.com"
        ];
      };
      DisablePocket = true;
      DisplayBookmarksToolbar = "newtab";
      DisplayMenuBar = "default-off";
      # DNSOverHTTPS = {
      #   Enabled = true;
      #   ProviderURL = "https://firefox.dns.nextdns.io/";
      #   Locked = true;
      #   Fallback = false;
      # };
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
        Snippets = false;
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
      # OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        Session = true;
        Locked = true;
      };
      SearchBar = "unified";
      SearchSuggestEnabled = true;
      TranslateEnabled = true;

      # about:config
      Preferences = {
        "browser.ctrlTab.sortByRecentlyUsed" = lock-true;
        "browser.ml.chat.enabled" = lock-true;
        "browser.ml.chat.provider" = {
          Value = "https://chatgpt.com";
          Status = "locked";
        };
        "browser.ml.chat.shortcuts" = lock-true;
        "browser.tabs.hoverPreview.enabled" = lock-true;
        "browser.tabs.inTitlebar" = {
          Value = 0;
          Status = "locked";
        };
        "sidebar.revamp" = lock-true;
        "sidebar.verticalTabs" = lock-true;
      };
    };
  };
}
