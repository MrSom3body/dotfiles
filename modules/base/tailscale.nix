{ lib, ... }: {
  flake.modules = {
    nixos.nixos = { config, ... }: {
      networking.firewall = {
        checkReversePath = "loose";
        trustedInterfaces = [ config.services.tailscale.interfaceName ];
        allowedUDPPorts = [ config.services.tailscale.port ];
      };

      systemd.services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ];

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
