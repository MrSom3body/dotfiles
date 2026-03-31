{ config, ... }:
{
  flake.modules = {
    nixos.desktop.imports = [ config.flake.modules.nixos.syncthing-server ];
    homeManager.desktop.imports = [ config.flake.modules.homeManager.syncthing ];
  };
}
