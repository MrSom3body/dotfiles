{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.shell;
in {
  imports = [
    ./bash.nix
    ./fish
    ./nushell.nix
  ];

  programs = {
    fish = mkIf cfg.fish.enable {
      functions = {
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
    };

    bash = mkIf cfg.bash.enable {
      shellAliases = {
        ip = "ip -c";
        l = "ls";
        icat = "${pkgs.timg}/bin/timg";
      };
    };
  };
}
