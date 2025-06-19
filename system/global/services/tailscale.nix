{lib, ...}: {
  services = {
    tailscale = {
      enable = lib.mkDefault true;
      useRoutingFeatures = lib.mkDefault "client";
      extraSetFlags = [
        # automatically disable exit node
        "--exit-node="
      ];
    };
  };
}
