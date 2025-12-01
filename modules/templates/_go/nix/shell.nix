{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          go
          gopls
          gotools
          go-tools
        ];

        shellHook = ''
          ${config.pre-commit.settings.shellHook}
        '';
      };
    };
}
