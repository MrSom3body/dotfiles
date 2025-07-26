{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.bundles.disk-utils;
in
{
  options.my.terminal.programs.bundles.disk-utils = {
    enable = mkEnableOption "disk related utilities";
  };

  config = mkIf cfg.enable {
    my.terminal.programs = {
      dust.enable = true;
      fd.enable = true;
    };

    home.packages = builtins.attrValues {
      inherit (pkgs)
        sd
        ;
    };
  };
}
