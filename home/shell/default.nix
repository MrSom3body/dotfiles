{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.shell;
in
{
  imports = [
    ./bash.nix
    ./fish
    ./nushell.nix
  ];

  options.my.shell = {
    enable = mkEnableOption "the fish & bash shells and some essential terminal programs";
  };

  config = mkIf cfg.enable {
    my = {
      shell = {
        fish.enable = true;
        bash.enable = true;
      };

      terminal.programs = {
        bat.enable = true;
        eza.enable = true;
        fzf.enable = true;
        ripgrep.enable = true;
        trash-cli.enable = true;
        zoxide.enable = true;
      };
    };

    programs = {
      fish = {
        functions = {
          ip = {
            body = "command ip -c $argv";
            wraps = "ip";
          };
          icat = {
            body = "${pkgs.timg}/bin/timg $argv";
            wraps = "${pkgs.timg}/bin/timg";
          };
          shell = {
            body = "nix shell --impure nixpkgs#$argv[1] -- $argv[2..-1]";
            wraps = "nix shell";
          };
        };
      };

      bash = {
        shellAliases = {
          ip = "ip -c";
          l = "ls";
          icat = "${pkgs.timg}/bin/timg";
        };
      };
    };
  };
}
