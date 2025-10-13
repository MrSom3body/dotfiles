{ config, ... }:
{
  flake.modules = {
    nixos."hosts/promethea_garnix" = {
      imports = [ config.flake.modules.nixos."hosts/promethea" ];
      disabledModules = [ ../../vmware.nix ];
    };

    homeManager."hosts/promethea_garnix" = {
      imports = [ config.flake.modules.homeManager."hosts/promethea" ];
      disabledModules = [ ../../school/_cisco.nix ];
    };
  };
}
