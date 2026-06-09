{ config, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
  inherit (meta.users.karun) email;
in
{
  flake.modules.homeManager.office = { config, ... }: {
    sops.secrets.dav-password.sopsFile = ../../secrets/calendars.yaml;
    sops.secrets.htl3r-cal.sopsFile = ../../secrets/calendars.yaml;

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
              "Nachhilfe"
              "Schule"
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
            url = "https://www.wien.gv.at/spezial/daten/ics/feiertage.ics";
          };
          vdirsyncer = {
            enable = true;
            collections = null;
            partialSync = "revert";
          };
        };

        HTL3R = {
          khal = {
            enable = true;
            color = "light blue";
            readOnly = true;
          };
          remote.type = "http";
          vdirsyncer = {
            enable = true;
            urlCommand = [
              "cat"
              config.sops.secrets.htl3r-cal.path
            ];
            collections = null;
            partialSync = "revert";
          };
        };
      };
    };
  };
}
