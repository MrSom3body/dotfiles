{
  lib,
  inputs,
  ...
}:
let
  inherit (import ../settings.nix) settings;

  specialArgs = {
    inherit inputs;
  };

  mkNixos =
    hostname:
    lib.nixosSystem {
      specialArgs = specialArgs // {
        settings = settings hostname;
      };
      modules = [ ./${hostname} ];
    };
in
{
  flake = {
    nixosConfigurations = {
      promethea = mkNixos "promethea";
      pandora = mkNixos "pandora";

      athenas = mkNixos "athenas";
      sanctuary = mkNixos "sanctuary";

      # hosts only for garnix
      promethea_garnix = mkNixos "promethea_garnix";
    };

    images = {
      sanctuary = inputs.self.nixosConfigurations.sanctuary.config.system.build.isoImage;
      athenas = inputs.self.nixosConfigurations.athenas.config.system.build.isoImage;
    };
  };
}
