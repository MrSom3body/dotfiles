{
  flake.modules = {
    nixos.server = {
      services.tailscale.useRoutingFeatures = "server";
    };
  };
}
