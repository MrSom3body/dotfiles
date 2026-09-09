{
  perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "dotfiles";

      buildInputs = config.pre-commit.settings.enabledPackages;

      packages =
        builtins.attrValues {
          inherit (pkgs)
            git
            just
            nix-fast-build
            ripgrep
            sops
            ssh-to-age
            ;
        }
        ++ [
          # language servers
          pkgs.kdePackages.qtdeclarative
        ];

      shellHook = ''
        ${config.pre-commit.settings.shellHook}
      '';
    };
  };
}
