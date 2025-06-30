{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.bundles.desktop-cli-utils;
in {
  options.my.programs.bundles.desktop-cli-utils = {
    enable = mkEnableOption "desktop cli utilities";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        libnotify # notification
        ripdrag # to drag files out of the terminal
        ;
    };
  };
}
