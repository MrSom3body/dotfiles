{ config, ... }:
{
  flake.modules = {
    nixos.desktop.imports = [ config.flake.modules.nixos.syncthing ];
    homeManager.desktop.imports = [ config.flake.modules.homeManager.syncthing ];
  };
}
