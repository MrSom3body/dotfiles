{
  services = {
    caddy.virtualHosts."jellyfin.sndh.dev" = {
      extraConfig = ''
        reverse_proxy http://localhost:8096
        import cloudflare
      '';
    };

    jellyfin = {
      enable = true;
    };
  };

  users.users.jellyfin.extraGroups = [
    "video"
    "render"
  ];

  networking.firewall = {
    allowedTCPPorts = [
      8096 # http traffic
    ];

    allowedUDPPorts = [
      1900 # service discovery
      7359 # client discovery
    ];
  };
}
