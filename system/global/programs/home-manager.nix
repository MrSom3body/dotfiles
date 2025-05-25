{
  lib,
  config,
  inputs,
  specialArgs,
  isInstall,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = lib.mkIf isInstall {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;

    users.karun.imports = [../../../hosts/${config.networking.hostName}/home.nix];
  };
}
