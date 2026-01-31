{ self, config, ... }:
{
  flake.modules.nixos.desktop = {
    system.autoUpgrade = {
      enable = self ? rev;
      flake = config.flake.meta.uri;
      upgrade = false;
      operation = "boot";
      dates = "05:00";
    };
  };
}
