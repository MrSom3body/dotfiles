{ config, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
  inherit (meta.users.karun) email;
in
{
  flake.modules.homeManager.office =
    { config, ... }:
    {
      sops.secrets.dav-password.sopsFile = ../../secrets/calendars.yaml;

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
                "cat"
                config.sops.secrets.dav-password.path
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
