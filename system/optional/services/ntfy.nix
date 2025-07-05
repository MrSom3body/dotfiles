{
  pkgs,
  config,
  ...
}: let
  cfg = config.services.ntfy-sh.settings;
in {
  sops.secrets.ntfy-env = {
    sopsFile = ../../../secrets/pandora/ntfy.env;
    format = "dotenv";
  };

  services = {
    caddy.virtualHosts."ntfy.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://${cfg.listen-http}
        import cloudflare
      '';
    };

    ntfy-sh = {
      enable = true;
      settings = {
        listen-http = "127.0.0.1:2586";
        base-url = "https://ntfy.sndh.dev";
        behind-proxy = true;

        auth-file = "/var/lib/ntfy-sh/user.db";
        auth-default-access = "deny-all";

        attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
        cache-file = "/var/lib/ntfy-sh/cache-file.db";
      };
    };
  };

  systemd.services.ntfy-setup = {
    enable = true;
    description = "Automatically add ntfy-sh users and ACLs";
    wants = [
      "network-online.target"
      "ntfy-sh.service"
    ];
    after = [
      "network-online.target"
      "ntfy-sh.service"
    ];
    wantedBy = ["multi-user.target"];
    path = [pkgs.ntfy-sh];
    script =
      # bash
      ''
        while IFS='=' read -r ntfy_user ntfy_user_pass; do
          username="''${ntfy_user#NTFY_}"
          username="''${username,,}"
          ntfy user del ''${username} || true
          NTFY_PASSWORD="''${ntfy_user_pass}" ntfy user add "''${username}"
        done < <(env | grep '^NTFY_')

        # make myself admin
        ntfy user change-role karun admin

        ### ACLs ###
        ntfy access --reset

        # arr
        ntfy access arr jellyseer rw
        ntfy access arr prowlarr rw
        ntfy access arr radarr rw
        ntfy access arr sonarr rw

        # miniflux
        ntfy access miniflux miniflux rw
      '';

    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.sops.secrets.ntfy-env.path;
      ReadOnlyPaths = "/nix/store";
      ReadWritePaths = [
        "/var/lib/private/ntfy-sh"
      ];
      ProtectSystem = "strict";
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };
}
