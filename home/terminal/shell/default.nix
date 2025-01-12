{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./fish

    ./starship.nix
    ./zoxide.nix
  ];

  programs = {
    fish.functions = {
      ip = {
        body = "ip -c $argv";
        wraps = "ip";
      };
      icat = {
        body = "${pkgs.libsixel}/bin/img2sixel $argv";
        wraps = "${pkgs.libsixel}/bin/img2sixel";
      };
    };

    bash.shellAliases = {
      ip = "ip -c";
      l = "ls";
      icat = "${pkgs.libsixel}/bin/img2sixel";
    };
  };

  home.sessionPath = ["$HOME/bin"];
}
