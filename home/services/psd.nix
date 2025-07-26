{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.psd;
in
{
  options.my.services.psd = {
    enable = mkEnableOption "the profile-sync-daemon service";
  };

  config = mkIf cfg.enable {
    services.psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
}
