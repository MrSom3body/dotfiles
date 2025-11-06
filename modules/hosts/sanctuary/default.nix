{ config, ... }:
let
  modules = [ "iso" ];
in
{
  flake = {
    images.sanctuary = config.flake.nixosConfigurations.sanctuary.config.system.build.isoImage;
    nixosConfigurations.sanctuary = config.flake.lib.mkSystems.linux "sanctuary";
    modules.nixos."hosts/sanctuary" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
    };
  };
}
