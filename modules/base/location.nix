{ config, ... }:
{
  flake.modules.nixos.nixos = { inherit (config.flake.meta) location; };
}
