{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.gammastep;
  useGeoclue = config.my.systemType >= 3;
in
{
  options.my.services.gammastep = {
    enable = mkEnableOption "the gammastep service";
  };

  config = mkIf cfg.enable {
    services.gammastep = {
      enable = true;

      provider = if useGeoclue then "geoclue2" else "manual";
      # don't bother with it it isn't my real location
      latitude = mkIf (!useGeoclue) 48.2083537;
      longitude = mkIf (!useGeoclue) 16.3725042;

      settings.general.adjustment-method = "wayland";
    };
  };
}
