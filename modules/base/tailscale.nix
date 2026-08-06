{ lib, ... }: {
  flake.modules.nixos.nixos = { config, ... }: {
    networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = lib.mkDefault "client";
      extraSetFlags = [
        # automatically disable exit node
        "--exit-node="
        "--operator=karun"
      ];
    };
  };
}
