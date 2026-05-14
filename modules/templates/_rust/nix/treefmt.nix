{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      programs = {
        rustfmt.enable = true;

        nixfmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;

        prettier.enable = true;
      };
    };
  };
}
