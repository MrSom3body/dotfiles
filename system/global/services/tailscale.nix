{lib, ...}: {
  services = {
    tailscale = {
      enable = lib.mkDefault true;
      useRoutingFeatures = lib.mkDefault "client";
    };
  };
}
