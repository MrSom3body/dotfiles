{
  inputs,
  system,
  pkgs,
  mkShell,
  ...
}:
mkShell {
  buildInputs = inputs.self.checks.${system}.pre-commit-hooks.enabledPackages;

  packages = with pkgs; [
    alejandra
    git
    just
  ];

  shellHook = ''
    ${inputs.self.checks.${system}.pre-commit-hooks.shellHook}

    tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "last 5 commits"
    git log --all --decorate --graph --oneline -5
    echo
    tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "status"
    git status --short
  '';
}
