{ lib, ... }:
{
  flake.modules = {
    nixos.base = {
      services = {
        tailscale = {
          enable = true;
          useRoutingFeatures = lib.mkDefault "client";
          extraSetFlags = [
            # automatically disable exit node
            "--exit-node="
          ];
        };
      };
    };
  };
}
