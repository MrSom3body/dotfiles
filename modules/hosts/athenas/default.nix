{ config, ... }:
let
  modules = [
    "desktop"
    "hyprland"
    "iso"
    "laptop"
    "shell"

    "bluetooth"
    "opentabletdriver"
    "printing"
  ];
in
{
  flake = {
    images.athenas = config.flake.nixosConfigurations.athenas.config.system.build.isoImage;
    nixosConfigurations.athenas = config.flake.lib.mkSystems.linux "athenas";
    modules.nixos."hosts/athenas" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;

      boot.supportedFilesystems = [ "ntfs" ]; # allow mounting windows
    };
  };
}
