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
            group = lib.mkOption {
              type = lib.types.str;
              default = "misc";
            };
            show = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
            public = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            external = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            alt-status-codes = lib.mkOption {
              type = lib.types.listOf lib.types.int;
              default = [ ];
            };
            gatus = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  defaultConditions = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                  };
                  conditions = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ ];
                  };
                };
              };
              default = { };
            };
          };
        }
      )
    );
  };

  config.flake.meta.services = {
    website = {
      domain = "karun.sndh.dev";
      icon = "mdi:web";
      external = true;
      public = true;
      group = "misc";
    };
    atuin = {
      port = 8987;
      group = "utils";
    };
    beszel = {
      port = 8090;
      group = "infra";
    };
    "ddns-updater" = {
      port = 8000;
      domain = "ddns.sndh.dev";
      group = "infra";
    };
    "firefox-send" = {
      port = 1443;
      domain = "send.sndh.dev";
      public = true;
      group = "utils";
    };
    flaresolverr = {
      port = 8191;
      domain = null;
      show = false;
      group = "infra";
    };
    gatus = {
      port = 3003;
      domain = "status.sndh.dev";
      group = "dash";
    };
    glance = {
      port = 8080;
      domain = "home.sndh.dev";
      group = "dash";
    };
    immich = {
      port = 2283;
      group = "media";
    };
    jellyfin = {
      port = 8096; # WARN don't change
      group = "media";
    };
    seerr = {
      port = 5055;
      group = "arr";
    };
    karakeep = {
      port = 3002;
      group = "apps";
    };
    loxone = {
      group = "home";
    };
    miniflux = {
      port = 7070;
      domain = "read.sndh.dev";
      group = "apps";
    };
    ntfy = {
      port = 2586;
      group = "utils";
    };
    ollama = {
      port = 11434;
      domain = null;
      show = false;
      group = "ai";
    };
    "open-webui" = {
      port = 3000;
      domain = "ai.sndh.dev";
      group = "ai";
    };
    prowlarr = {
      port = 9696;
      group = "arr";
    };
    radarr = {
      port = 7878;
      group = "arr";
    };
    radicale = {
      port = 5232;
      domain = "dav.sndh.dev";
      group = "apps";
    };
    searx = {
      port = 8888;
      domain = "search.sndh.dev";
      icon = "di:searxng";
      alt-status-codes = [ 429 ];
      public = true;
      group = "apps";
    };
    sonarr = {
      port = 8989;
      group = "arr";
    };
    syncthing = {
      port = 8384;
      domain = null;
      show = false;
      group = "utils";
    };
    transmission = {
      port = 9091;
      alt-status-codes = [ 401 ];
      group = "arr";
    };
    wakapi = {
      port = 3001;
      domain = "waka.sndh.dev";
      public = true;
      group = "utils";
    };
  };
}
