{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit (pkgs)
            git
            ;
        };

        buildInputs = [ ];

        shellHook = ''
          ${config.pre-commit.settings.shellHook}
        '';
      };
    };
}
