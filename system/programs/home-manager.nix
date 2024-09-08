{
  inputs,
  specialArgs,
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
  };
}
