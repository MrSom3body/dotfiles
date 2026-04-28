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

      accounts.contact = {
        basePath = "${config.xdg.dataHome}/contacts";
        accounts = {
          contacts = {
            khal = {
              enable = true;
              addresses = [ email ];
              collections = [ "5ff7c5b5-503e-465d-bede-fc49b55f9168" ];
            };
            remote = {
              type = "carddav";
              url = "https://dav.sndh.dev";
              userName = email;
              passwordCommand = [
                "cat"
                config.sops.secrets.dav-password.path
              ];
            };
            vdirsyncer = {
              enable = true;
              metadata = [ "displayname" ];
              collections = [ "5ff7c5b5-503e-465d-bede-fc49b55f9168" ];
            };
          };
        };
      };
    };
}
