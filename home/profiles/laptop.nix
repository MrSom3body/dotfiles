{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my;
in
{
  config = mkIf (cfg.systemType >= 3) {
    services.power-monitor.enable = true;
  };
}
