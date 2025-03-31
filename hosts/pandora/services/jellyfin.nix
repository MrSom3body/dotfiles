{
  imports = [
    ../../../system/services/jellyfin.nix
  ];

  services.caddy.virtualHosts."jellyfin.sndh.dev" = {
    extraConfig = ''
      reverse_proxy http://localhost:8096
      import cloudflare
    '';
  };
}
