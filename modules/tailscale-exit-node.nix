{
  flake.modules.nixos.tailscale-exit-node = {
    services = {
      tailscale = {
        extraSetFlags = [ "--advertise-exit-node" ];
        useRoutingFeatures = "both";
      };
    };
  };
}
