{
  self,
  inputs,
  pkgs,
  ...
}: {
  default = pkgs.mkShell {
    name = "dotfiles";

    buildInputs = self.checks.${pkgs.system}.pre-commit-check.enabledPackages;

    packages =
      builtins.attrValues {
        inherit
          (pkgs)
          alejandra
          git
          just
          neovim # a editor if I'm dumb and remove it somehow
          sops
          ;
      }
      ++ [
        inputs.deploy-rs.packages.${pkgs.system}.default
      ];

    shellHook = ''
      ${self.checks.${pkgs.system}.pre-commit-check.shellHook}

      tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "last 5 commits"
      git log --all --decorate --graph --oneline -5
      echo
      tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "status"
      git status --short
    '';
  };
}
