{
  lib,
  config,
  inputs,
  specialArgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.home-manager;
in {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  options.my.home-manager = {
    enable =
      mkEnableOption "home-manager"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = specialArgs;

      users.karun.imports = [../../../hosts/${config.networking.hostName}/home.nix];
    };
  };
}
