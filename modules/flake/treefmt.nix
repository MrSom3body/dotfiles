{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    treefmt = {
      settings = {
        excludes = [
          "**/hardware-configuration.nix"
          ".github/workflows/*"
        ];
      };

      programs = {
        nixfmt = {
          enable = true;
          strict = true;
        };
        deadnix.enable = true;
        statix.enable = true;

        prettier.enable = true;
      };
    };
  };
}
