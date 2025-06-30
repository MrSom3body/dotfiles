{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.bat;
in {
  options.my.terminal.programs.bat = {
    enable = mkEnableOption "bat a cat alternative";
  };

  config = mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;
        extraPackages = builtins.attrValues {
          inherit
            (pkgs.bat-extras)
            batman
            prettybat
            ;
        };
      };

      fish.functions = {
        man = {
          body = "batman $argv";
          wraps = "batman";
        };
        cat = {
          body = "bat $argv";
          wraps = "bat";
        };
      };

      bash.shellAliases = {
        cat = "bat";
        man = "batman";
      };
    };
  };
}
