{ pkgs, ... }:
{
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
        urls = [ { template = "https://nixpkgs-tracker.ocfox.me/?pr={searchTerms}"; } ];
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
    ### my overrides ###
    "browser.ctrlTab.sortByRecentlyUsed" = true;
    "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
    # disable password manager stuff
    "signon.autofillForms" = false;
    "signon.firefoxRelay.feature" = "";
    "signon.generation.enabled" = false;
    "signon.management.page.breach-alerts.enabled" = true;
    "signon.rememberSignons" = false;

    ### fastfox ###
    # general
    "gfx.content.skia-font-cache-size" = 32;

    # gfx
    "gfx.canvas.accelerated.cache-items" = 32768;
    "gfx.canvas.accelerated.cache-size" = 4096;
    "webgl.max-size" = 16384;

    # disk cache
    "browser.cache.disk.enable" = false;

    # memory cache
    "browser.cache.memory.capacity" = 131072;
    "browser.cache.memory.max_entry_size" = 20480;
    "browser.sessionhistory.max_total_viewers" = 4;
    "browser.sessionstore.max_tabs_undo" = 10;

    # media cache
    "media.memory_cache_max_size" = 262144;
    "media.memory_caches_combined_limit_kb" = 1048576;
    "media.cache_readahead_limit" = 600;
    "media.cache_resume_threshold" = 300;

    # image cache
    "image.cache.size" = 10485760;
    "image.mem.decode_bytes_at_a_time" = 65536;

    # network
    "network.http.max-connections" = 1800;
    "network.http.max-persistent-connections-per-server" = 10;
    "network.http.max-urgent-start-excessive-connections-per-host" = 5;
    "network.http.request.max-start-delay" = 5;
    "network.http.pacing.requests.enabled" = false;
    "network.dnsCacheEntries" = 10000;
    "network.dnsCacheExpiration" = 3600;
    "network.ssl_tokens_cache_capacity" = 10240;

    # speculative loading
    "network.http.speculative-parallel-limit" = 0;
    "network.dns.disablePrefetch" = true;
    "network.dns.disablePrefetchFromHTTPS" = true;
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.places.speculativeConnect.enabled" = false;
    "network.prefetch-next" = false;
    "network.predictor.enabled" = false;

    ### securefox ###
    # trakcing protection
    "browser.contentblocking.category" = "strict";
    "privacy.trackingprotection.allow_list.baseline.enabled" = true;
    "browser.download.start_downloads_in_tmp_dir" = true;
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.uitour.enabled" = false;
    "privacy.globalprivacycontrol.enabled" = true;

    # OCSP & Certs/ HPKP
    "security.OCSP.enabled" = 0;
    "security.csp.reporting.enabled" = false;

    # SSL/TLS
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "browser.xul.error_pages.expert_bad_cert" = true;
    "security.tls.enable_0rtt_data" = false;

    # disk avoidance
    "browser.privatebrowsing.forceMediaMemoryCache" = true;
    "browser.sessionstore.interval" = 60000;

    # shutdown & sanitizing
    "privacy.history.custom" = true;
    "browser.privatebrowsing.resetPBM.enabled" = true;

    # search & url bar
    "browser.urlbar.trimHttps" = true;
    "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
    "browser.search.separatePrivateDefault.ui.enabled" = true;
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.quicksuggest.enabled" = false;
    "browser.urlbar.groupLabels.enabled" = false;
    "browser.formfill.enable" = false;
    "network.IDN_show_punycode" = true;

    # passwords
    "signon.formlessCapture.enabled" = false;
    "signon.privateBrowsingCapture.enabled" = false;
    "network.auth.subresource-http-auth-allow" = 1;
    "editor.truncate_user_pastes" = false;

    # mixed content & cross site
    "security.mixed_content.block_display_content" = true;
    "pdfjs.enableScripting" = false;

    # extensions
    "extensions.enabledScopes" = 5;

    # headers / referers
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    # containers
    "privacy.userContext.ui.enabled" = true;

    # safe browsing
    "browser.safebrowsing.downloads.remote.enabled" = false;

    # mozilla
    "permissions.default.desktop-notification" = 2;
    "permissions.default.geo" = 2;
    "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
    "browser.search.update" = false;
    "permissions.manager.defaultsUrl" = "";
    "extensions.getAddons.cache.enabled" = false;

    # telemetry
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "datareporting.usage.uploadEnabled" = false;

    # experiments
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    # crash reports
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;

    ### peskyfox ###
    # mozilla ui
    "browser.privatebrowsing.vpnpromourl" = "";
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.preferences.moreFromMozilla" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;
    "browser.profiles.enabled" = true;

    # theme adjustments
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.compactmode.show" = true;

    # ai
    "browser.ml.enable" = false;
    "browser.ml.chat.enabled" = false;
    "browser.ml.chat.menu" = false;
    "browser.tabs.groups.smart.enabled" = false;
    "browser.ml.linkPreview.enabled" = false;

    # fullscreen notice
    "full-screen-api.transition-duration.enter" = "0 0";
    "full-screen-api.transition-duration.leave" = "0 0";
    "full-screen-api.warning.timeout" = 0;

    # url bar
    "browser.urlbar.trending.featureGate" = false;

    # net tab page
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;

    # downloads
    "browser.download.manager.addToRecentDocs" = false;

    # pdf
    "browser.download.open_pdf_attachments_inline" = true;

    # tab behavior
    "browser.bookmarks.openInTabClosesMenu" = false;
    "browser.menu.showViewImageInfo" = true;
    "findbar.highlightAll" = true;
    "layout.word_select.eat_space_to_next_word" = false;
  };
}
