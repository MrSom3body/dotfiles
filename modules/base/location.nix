{ config, ... }:
{
  flake.modules.nixos.base = {
    inherit (config.flake.meta) location;
  };
}
