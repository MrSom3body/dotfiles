{
  imports = [
    ./bash.nix
    ./fish

    ./starship.nix
    ./zoxide.nix
  ];

  home.sessionPath = ["$HOME/bin"];
}
