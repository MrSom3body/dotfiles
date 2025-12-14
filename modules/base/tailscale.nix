{
  flake.modules = {
    nixos.base = {
      services = {
        tailscale = {
          enable = true;
          useRoutingFeatures = "both";
          extraSetFlags = [
            # automatically disable exit node
            "--exit-node="
            "--operator=karun"
          ];
        };
      };
    };
  };
}
