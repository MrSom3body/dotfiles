{ pkgs, ... }:
{
  settings = {
    "browser.download.start_downloads_in_tmp_dir" = true;
    "browser.ml.linkPreview.enabled" = true;
    "browser.tabs.groups.enabled" = true;
    "browser.tabs.groups.smart.enabled" = true;
    "cookiebanners.service.mode" = 2;
    "cookiebanners.service.mode.privateBrowsing" = 2;
    "cookiebanners.ui.desktop.enabled" = 2;
    "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
  };

  search = {
    force = true;
    default = "searxng";
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
      "mynixos" = {
        urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
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
}
