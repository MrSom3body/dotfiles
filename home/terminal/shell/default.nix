{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./fish

    ./starship.nix
    ./zoxide.nix
  ];

  home = {
    sessionPath = ["$HOME/bin"];
    shellAliases = {
      ip = "ip -c";
      l = "ls";
      icat = "${pkgs.libsixel}/bin/img2sixel";
      cat = "bat";
      man = "batman";
      rm = "trash-put";
    };
  };
}
