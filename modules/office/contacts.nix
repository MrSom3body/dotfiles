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
                "${pass}"
                "dav.sndh.dev/${email}"
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
