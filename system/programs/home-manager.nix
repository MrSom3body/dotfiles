{
  inputs,
  config,
  specialArgs,
  dotfiles,
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

    users.${dotfiles.user}.imports = [../../hosts/${config.networking.hostName}/home.nix];
  };
}
