{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.syncthing;
in
{
  options.my.services.syncthing = {
    enable = mkEnableOption "the syncthing service";
  };

  config = mkIf cfg.enable {
    services.syncthing.enable = true;
  };
}
