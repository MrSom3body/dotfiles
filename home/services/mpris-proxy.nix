{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.mpris-proxy;
in
{
  options.my.services.mpris-proxy = {
    enable = mkEnableOption "the mpris-proxy service to enable bluetooth device to play/pause";
  };

  config = mkIf cfg.enable {
    services.mpris-proxy = {
      enable = true;
    };
  };
}
