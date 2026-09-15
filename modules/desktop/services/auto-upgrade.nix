{ config, ... }:
let
  inherit (config) flake;
in
{
  flake.modules.nixos.desktop = { config, ... }: {
    system.autoUpgrade = {
      enable = true;
      flake = flake.meta.uri;
      upgrade = false;
      operation = "boot";
      dates = "05:00";
    };

    systemd.services.nixos-upgrade.preStart = ''
      echo "Waiting for systemd-networkd to have an online interface..."
      ${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any --dns -q
    '';
  };
}
