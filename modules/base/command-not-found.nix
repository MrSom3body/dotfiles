{ inputs, ... }:
{
  flake.modules = {
    nixos.base = {
      imports = [
        inputs.nix-index-database.nixosModules.nix-index
      ];

      programs = {
        command-not-found.enable = false;
        nix-index.enable = true;
      };
    };

    homeManager.base = {
      programs.command-not-found.enable = false;
    };
  };
}
