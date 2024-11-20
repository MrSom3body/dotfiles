{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./fish

    ./starship.nix
    ./zoxide.nix
  ];

  home.shellAliases = {
    ip = "ip -c";
    l = "ls";
    icat = "${pkgs.libsixel}/bin/img2sixel";
    mkdev = "nix flake new -t \"github:numtide/devshell\"";
  };

  home.sessionPath = ["$HOME/bin"];
}
