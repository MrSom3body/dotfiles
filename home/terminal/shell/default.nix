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
        body = "${pkgs.timg}/bin/timg $argv";
        wraps = "${pkgs.timg}/bin/timg";
      };
    };

    bash.shellAliases = {
      ip = "ip -c";
      l = "ls";
      icat = "${pkgs.timg}/bin/timg";
    };
  };

  home.sessionPath = ["$HOME/bin"];
}
