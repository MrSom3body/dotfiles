{...}: {
  imports = [
    ./bash.nix
    ./fish

    ./starship.nix
    ./zoxide.nix
  ];

  home.shellAliases = {
    ip = "ip -c";
    l = "ls";
    mkdev = "nix flake new -t \"github:numtide/devshell\"";
  };

  home.sessionPath = ["$HOME/bin"];
}
