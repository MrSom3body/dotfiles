{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.bundles.networking-utils;
in {
  options.my.programs.bundles.networking-utils = {
    enable = mkEnableOption "networking related programs";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        dig
        iputils
        nmap
        speedtest-cli
        ;
    };
  };
}
