{ config, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
  inherit (meta.users.karun) email;
in
{
  flake.modules.homeManager.office = { config, pkgs, ... }: {
    sops.secrets.dav-password.sopsFile = ../../secrets/user/calendars.yaml;
    sops.secrets.wallos-api-key.sopsFile = ../../secrets/user/calendars.yaml;

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

        subscriptions = {
          khal = {
            enable = true;
            color = "light green";
            readOnly = true;
          };
          remote.type = "http";
          vdirsyncer = {
            enable = true;
            collections = null;
            urlCommand = [
              (toString (
                pkgs.writeShellScript "wallos-ical-url" ''
                  printf '%s%s' \
                    '${meta.services.wallos.url}/api/subscriptions/get_ical_feed.php?api_key=' \
                    "$(cat ${config.sops.secrets.wallos-api-key.path})"
                ''
              ))
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
