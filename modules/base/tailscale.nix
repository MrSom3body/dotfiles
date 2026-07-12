{ lib, ... }: {
  flake.modules = {
    nixos.nixos = { config, ... }: {
      networking.firewall = {
        trustedInterfaces = [ config.services.tailscale.interfaceName ];
        allowedUDPPorts = [ config.services.tailscale.port ];
      };

      services = {
        tailscale = {
          enable = true;
          useRoutingFeatures = lib.mkDefault "client";
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
