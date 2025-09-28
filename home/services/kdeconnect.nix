{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.kdeconnect;
in
{
  options.my.services.kdeconnect = {
    enable = mkEnableOption "the kdeconnect service";
  };

  config = mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
      indicator = true;
    };
  };
}
