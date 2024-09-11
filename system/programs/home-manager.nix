{
  inputs,
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

    users.${dotfiles.username}.imports = [../../hosts/${dotfiles.hostname}/home.nix];
  };
}
