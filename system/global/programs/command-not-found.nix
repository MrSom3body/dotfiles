{inputs, ...}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  programs = {
    command-not-found.enable = false;
    nix-index.enable = true;
  };
}
