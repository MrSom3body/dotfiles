{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.utils;
in
{
  options.my.utils = {
    enable = mkEnableOption "various utils from disk usage analyzer to weather app";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        # GNOME utilities
        baobab # Disk Usage Analyzer
        gnome-calculator
        gnome-clocks
        gnome-disk-utility
        gnome-weather
        snapshot # Camera App
        ;
    };
  };
}
