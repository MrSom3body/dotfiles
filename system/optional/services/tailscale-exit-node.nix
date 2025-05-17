{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../global/services/tailscale.nix
  ];

  services = {
    tailscale = {
      extraSetFlags = ["--advertise-exit-node"];
      useRoutingFeatures = "both";
    };

    networkd-dispatcher = lib.optionalAttrs (config.services.tailscale.useRoutingFeatures == "server") {
      enable = true;
      rules."50-tailscale" = {
        onState = ["routable"];
        script = ''
          ${lib.getExe pkgs.ethtool} -K eno1 rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };
}
