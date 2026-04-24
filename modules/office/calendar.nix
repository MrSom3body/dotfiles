{ config, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
  inherit (meta.users.karun) email;
in
{
  flake.modules.homeManager.office =
    { lib, config, ... }:
    let
      pass = lib.getExe config.programs.password-store.package;
    in
    {
      accounts.calendar = {
        basePath = "${config.xdg.dataHome}/calendars";
        accounts = {
          personal = {
            primary = true;
            primaryCollection = "Persönlich";
            khal = {
              enable = true;
              addresses = [ email ];
              type = "discover";
            };
            remote = {
              type = "caldav";
              url = "https://dav.sndh.dev";
              userName = email;
              passwordCommand = [
                "${pass}"
                "dav.sndh.dev/${email}"
              ];
            };
            vdirsyncer = {
              enable = true;
              metadata = [
                "color"
                "displayname"
              ];
              collections = [
                "Persönlich"
                "Schule"
              ];
            };
          };
        };
      };
    };
}
