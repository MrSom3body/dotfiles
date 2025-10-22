{ self, config, ... }:
{
  flake.modules.nixos.base = {
    system.autoUpgrade = {
      enable = self ? rev;
      flake = config.flake.meta.uri;
      upgrade = false;
      dates = "03:00";
    };
  };
}
