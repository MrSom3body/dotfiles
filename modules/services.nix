{
  flake = {
    meta.services = {
      "atuin" = {
        port = 8987;
        domain = "atuin.sndh.dev";
        icon = "di:atuin";
        show = true;
      };
      "beszel" = {
        port = 8090;
        domain = "beszel.sndh.dev";
        icon = "di:beszel";
        show = true;
      };
      "ddns-updater" = {
        port = 8000;
        domain = "ddns.sndh.dev";
        icon = "di:ddns-updater";
        show = true;
      };
      "firefox-send" = {
        port = 1443;
        domain = "send.sndh.dev";
        icon = "di:firefox-send";
        show = true;
      };
      "flaresolverr" = {
        port = 8191;
      };
      "glance" = {
        port = 8080;
        domain = "home.sndh.dev";
        icon = "di:glance";
        show = true;
      };
      "immich" = {
        port = 2283;
        domain = "immich.sndh.dev";
        icon = "di:immich";
        show = true;
      };
      "jellyfin" = {
        port = 8096; # WARN don't change
        domain = "jellyfin.sndh.dev";
        icon = "di:jellyfin";
        show = true;
      };
      "jellyseerr" = {
        port = 5055;
        domain = "jellyseerr.sndh.dev";
        icon = "di:jellyseerr";
        show = true;
      };
      "karakeep" = {
        port = 9222;
        domain = "karakeep.sndh.dev";
        icon = "di:karakeep";
        show = true;
      };
      "loxone" = {
        domain = "loxone.sndh.dev";
        icon = "di:loxone";
        show = true;
      };
      "meilisearch" = {
        port = 7700;
      };
      "miniflux" = {
        port = 7070;
        domain = "read.sndh.dev";
        icon = "di:miniflux";
        show = true;
      };
      "ntfy" = {
        port = 2586;
        domain = "ntfy.sndh.dev";
        icon = "di:ntfy";
        show = true;
      };
      "ollama" = {
        port = 11434;
      };
      "open-webui" = {
        port = 3000;
        domain = "ai.sndh.dev";
        icon = "di:open-webui";
        show = true;
      };
      "prowlarr" = {
        port = 9696;
        domain = "prowlarr.sndh.dev";
        icon = "di:prowlarr";
        show = true;
      };
      "radarr" = {
        port = 7878;
        domain = "radarr.sndh.dev";
        icon = "di:radarr";
        show = true;
      };
      "searx" = {
        port = 8888;
        domain = "search.sndh.dev";
        icon = "di:searxng";
        show = true;
      };
      "sonarr" = {
        port = 8989;
        domain = "sonarr.sndh.dev";
        icon = "di:sonarr";
        show = true;
      };
      "syncthing" = {
        port = 8384;
      };
      "transmission" = {
        port = 9091;
        domain = "transmission.sndh.dev";
        icon = "di:transmission";
        alt-status-codes = [ 401 ];
        show = true;
      };
    };
  };
}
