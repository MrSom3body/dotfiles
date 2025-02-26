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
        body = "command ip -c $argv";
        wraps = "ip";
      };
      icat = {
        body = "${pkgs.viu}/bin/viu $argv";
        wraps = "${pkgs.viu}/bin/viu";
      };
    };

    bash.shellAliases = {
      ip = "ip -c";
      l = "ls";
      icat = "${pkgs.viu}/bin/viu";
    };
  };

  home.sessionPath = ["$HOME/bin"];
}
