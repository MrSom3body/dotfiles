{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib) mkDefault;

  inherit (config.flake.meta) location;
in
{
  flake.modules.homeManager.desktop =
    { config, ... }:
    let
      cfg = config.services.gammastep;
    in
    {
      services.gammastep = {
        enable = true;

        temperature = {
          day = 6500;
          night = 3700;
        };

        latitude = mkIf (cfg.provider == "manual") (mkDefault location.latitude);
        longitude = mkIf (cfg.provider == "manual") (mkDefault location.longitude);

        settings.general.adjustment-method = "wayland";
      };
    };
}
