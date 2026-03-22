{ config, ... }:
{
  flake.modules.nixos.desktop = {
    system.autoUpgrade = {
      enable = true;
      flake = config.flake.meta.uri;
      upgrade = false;
      operation = "boot";
      dates = "12:00";
    };
  };
}
