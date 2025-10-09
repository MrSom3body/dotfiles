{
  perSystem =
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "dotfiles";

        buildInputs = config.pre-commit.settings.enabledPackages;

        packages =
          builtins.attrValues {
            inherit (pkgs)
              git
              just
              nixfmt-tree
              ripgrep
              sops
              ;
          }
          ++ [
            inputs'.deploy-rs.packages.default
            inputs'.helix.packages.default # a editor if I'm dumb and remove it somehow
          ];

        shellHook = ''
          ${config.pre-commit.installationScript}

          tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "last 5 commits"
          git log --all --decorate --graph --oneline -5
          echo
          tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "status"
          git status --short
        '';
      };
    };
}
