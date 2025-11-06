{ inputs, ... }:
{
  flake.modules = {
    nixos.nixos = {
      imports = [
        inputs.nix-index-database.nixosModules.nix-index
      ];

      programs = {
        command-not-found.enable = false;
        nix-index.enable = true;
      };
    };

    homeManager.homeManager = {
      programs.command-not-found.enable = false;
    };
  };
}
