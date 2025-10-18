{ config, inputs, ... }:
{
  flake.modules.nixos.base = {
    system.autoUpgrade = {
      enable = inputs.self ? rev;
      flake = config.flake.meta.uri;
      upgrade = false;
      dates = "03:00";
    };
  };
}
