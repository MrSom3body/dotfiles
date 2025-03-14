{
  lib,
  config,
  pkgs,
  ...
}: {
  services = {
    tailscale = {
      enable = true;
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
