{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.bundles.desktop-utils;
in
{
  options.my.terminal.programs.bundles.desktop-utils = {
    enable = mkEnableOption "desktop cli utilities";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        libnotify # notification
        ripdrag # to drag files out of the terminal
        ;
    };
  };
}
