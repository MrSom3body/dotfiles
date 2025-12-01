{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    treefmt = {
      programs = {
        gofmt.enable = true;

        nixfmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;

        prettier.enable = true;
      };
    };
  };
}
