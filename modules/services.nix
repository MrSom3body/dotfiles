{ lib, ... }: {
  options.flake.meta.services = lib.mkOption {
    description = "Global registry of homelab services";
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }: {
          options = {
            port = lib.mkOption {
              type = lib.types.nullOr lib.types.port;
              default = null;
            };
            domain = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = "${name}.sndh.dev";
            };
            url = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              readOnly = true;
              default = if config.domain != null then "https://${config.domain}" else null;
            };
            icon = lib.mkOption {
              type = lib.types.str;
              default = "di:${name}";
            };
            show = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
            public = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            alt-status-codes = lib.mkOption {
              type = lib.types.listOf lib.types.int;
              default = [ ];
            };
          };
        }
      )
    );
  };

  config.flake.meta.services = {
    atuin.port = 8987;
    beszel.port = 8090;
    "ddns-updater" = {
      port = 8000;
      domain = "ddns.sndh.dev";
    };
    "firefox-send" = {
      port = 1443;
      domain = "send.sndh.dev";
      public = true;
    };
    flaresolverr = {
      port = 8191;
      domain = null;
      show = false;
    };
    gatus = {
      port = 3003;
      domain = "status.sndh.dev";
    };
    glance = {
      port = 8080;
      domain = "home.sndh.dev";
    };
    immich.port = 2283;
    jellyfin = {
      port = 8096; # WARN don't change
    };
    seerr.port = 5055;
    karakeep.port = 3002;
    loxone = { };
    miniflux = {
      port = 7070;
      domain = "read.sndh.dev";
    };
    ntfy.port = 2586;
    ollama = {
      port = 11434;
      domain = null;
      show = false;
    };
    "open-webui" = {
      port = 3000;
      domain = "ai.sndh.dev";
    };
    prowlarr.port = 9696;
    radarr.port = 7878;
    radicale = {
      port = 5232;
      domain = "dav.sndh.dev";
    };
    searx = {
      port = 8888;
      domain = "search.sndh.dev";
      icon = "di:searxng";
      alt-status-codes = [ 429 ];
      public = true;
    };
    sonarr.port = 8989;
    syncthing = {
      port = 8384;
      domain = null;
      show = false;
    };
    transmission = {
      port = 9091;
      alt-status-codes = [ 401 ];
    };
    wakapi = {
      port = 3001;
      domain = "waka.sndh.dev";
      public = true;
    };
  };
}
