{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./fish
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
      run = {
        body = "nix run --impure nixpkgs#$argv[1] -- $argv[2..-1]";
        wraps = "nix run";
      };
      shell = {
        body = "nix shell --impure nixpkgs#$argv[1] -- $argv[2..-1]";
        wraps = "nix shell";
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
