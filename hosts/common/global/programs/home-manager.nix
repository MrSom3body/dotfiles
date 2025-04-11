{
  config,
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

    users.karun.imports = [../../../../hosts/${config.networking.hostName}/home.nix];
  };
}
