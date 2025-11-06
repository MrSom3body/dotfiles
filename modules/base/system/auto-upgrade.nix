{ self, config, ... }:
{
  flake.modules.nixos.nixos = {
    system.autoUpgrade = {
      enable = self ? rev;
      flake = config.flake.meta.uri;
      upgrade = false;
      dates = "03:00";
      rebootWindow = {
        lower = "02:00";
        upper = "04:00";
      };
    };
  };
}
