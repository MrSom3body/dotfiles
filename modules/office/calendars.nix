{ config, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
  inherit (meta.users.karun) email;
in
{
  flake.modules.homeManager.office = { config, ... }: {
    sops.secrets.dav-password.sopsFile = ../../secrets/user/calendars.yaml;

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
              "Arbeit"
              "Nachhilfe"
            ];
          };
        };

        Feiertage = {
          khal = {
            enable = true;
            color = "light red";
            readOnly = true;
          };
          remote = {
            type = "http";
            url = "https://calendar.google.com/calendar/ical/de.austrian%23holiday%40group.v.calendar.google.com/public/basic.ics";
          };
          vdirsyncer = {
            enable = true;
            collections = null;
            partialSync = "revert";
          };
        };
      };
    };
  };
}
