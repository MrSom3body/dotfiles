{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    treefmt = {
      settings = {
        excludes = [ "**/hardware-configuration.nix" ];
      };

      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;

        prettier.enable = true;
      };
    };
  };
}
