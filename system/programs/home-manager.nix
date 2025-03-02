{
  inputs,
  config,
  specialArgs,
  settings,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;

    users.${settings.user}.imports = [../../hosts/${config.networking.hostName}/home.nix];
  };
}
