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
  config = mkIf (cfg.systemType >= 2) {
    my = {
      desktop.enable = true;

      terminal = {
        programs = {
          bundles = {
            desktop-utils.enable = true;
          };
        };
      };
    };

    services.mpris-proxy.enable = true;
  };
}
