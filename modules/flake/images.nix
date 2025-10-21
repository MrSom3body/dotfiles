{ lib, config, ... }:
let
  prefix = "iso/";
  collectImageModules = modules: lib.filterAttrs (name: _: lib.hasPrefix prefix name) modules;
in
{
  flake.images = lib.pipe (collectImageModules config.flake.modules.nixos) [
    (lib.mapAttrs' (
      hostname: _: rec {
        name = lib.removePrefix prefix hostname;
        value = config.flake.nixosConfigurations.${name}.config.system.build.isoImage;
      }
    ))
  ];
}
