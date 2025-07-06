{
  services.caddy = {
    virtualHosts = {
      "loxone.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://10.0.0.10
          import cloudflare
        '';
      };
    };
  };
}
