{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.trash-cli;
in {
  options.my.programs.trash-cli = {
    enable = mkEnableOption "trash-cli";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.trash-cli];

    programs = {
      fish.functions.rm = {
        body = "trash-put $argv";
        wraps = "trash-put";
      };

      bash.shellAliases.rm = "trash-put";
    };
  };
}
