{config, ...}: let
  cfg = config.services.ntfy-sh.settings;
in {
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

        attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
        cache-file = "/var/lib/ntfy-sh/cache-file.db";
      };
    };
  };
}
