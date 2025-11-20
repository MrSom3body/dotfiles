{ lib, ... }:
{
  flake.modules.homeManager.desktop =
    { osConfig, ... }:
    let
      inherit (lib) mkIf;
      useGeoclue = osConfig.services.geoclue2.enable;
    in
    {
      services.gammastep = {
        enable = true;

        temperature = {
          day = 6500;
          night = 3700;
        };

        provider = if useGeoclue then "geoclue2" else "manual";
        # don't bother with it it isn't my real location
        latitude = mkIf (!useGeoclue) 48.2083537;
        longitude = mkIf (!useGeoclue) 16.3725042;

        settings.general.adjustment-method = "wayland";
      };
    };
}
