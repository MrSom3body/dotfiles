{ pkgs, ... }: {
  search = {
    force = true;
    default = "Brave";
    engines = {
      "searxng" = {
        urls = [ { template = "https://search.sndh.dev/search?q={searchTerms}"; } ];
        icon = "https://search.sndh.dev/favicon.ico";
        definedAliases = [ "@sx" ];
      };
      "amazon" = {
        urls = [ { template = "https://amazon.de/s?k={searchTerms}"; } ];
        icon = "https://amazon.de/favicon.ico";
        definedAliases = [ "@a" ];
      };
      "Brave" = {
        urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
        icon = "https://brave.com/favicon.ico";
        definedAliases = [
          "@brave"
          "@br"
        ];
      };
      "protondb" = {
        urls = [ { template = "https://protondb.com/search?q={searchTerms}"; } ];
        icon = "https://protondb.com/favicon.ico";
        definedAliases = [ "@pdb" ];
      };
      "github" = {
        urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
        icon = "https://github.com/favicon.ico";
        definedAliases = [ "@gh" ];
      };
      "alternativeto" = {
        urls = [ { template = "https://alternativeto.net/browse/search/?q={searchTerms}"; } ];
        icon = "https://alternativeto.net/favicon.ico";
        definedAliases = [ "@alt" ];
      };
      "youtube" = {
        urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
        icon = "https://www.youtube.com/favicon.ico";
        definedAliases = [ "@yt" ];
      };
      "nixos-wiki" = {
        urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
        icon = "https://wiki.nixos.org/favicon.png";
        definedAliases = [ "@nw" ];
      };
      "nüschtos-search" = {
        urls = [ { template = "https://search.nüschtos.de/?query={searchTerms}"; } ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@no" ];
      };
      "nix-packages" = {
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
        definedAliases = [ "@np" ];
      };
      "nixpkgs-pr" = {
        urls = [ { template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}"; } ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@npr" ];
      };
      "subreddit" = {
        urls = [ { template = "https://reddit.com/r/{searchTerms}"; } ];
        icon = "https://reddit.com/favicon.png";
        definedAliases = [ "r/" ];
      };
    };
  };

  settings = {
    "browser.ctrlTab.sortByRecentlyUsed" = true;
    "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;

    # disable password manager stuff
    "signon.autofillForms" = false;
    "signon.firefoxRelay.feature" = "";
    "signon.generation.enabled" = false;
    "signon.management.page.breach-alerts.enabled" = true;
    "signon.rememberSignons" = false;
  };
}
