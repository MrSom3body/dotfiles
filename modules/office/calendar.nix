{ config, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
  inherit (meta.users.karun) email;
in
{
  flake.modules.homeManager.office =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      pass = lib.getExe config.programs.password-store.package;
    in
    {
      accounts.calendar = {
        basePath = "Calendars";
        accounts = {
          personal = {
            primary = true;
            primaryCollection = "Persönlich";
            khal = {
              enable = true;
              addresses = [ email ];
              type = "discover";
            };
            remote = rec {
              type = "caldav";
              url = "https://dav.sndh.dev";
              userName = meta.users.karun.email;
              passwordCommand = [
                "${pass}"
                "dav.sndh.dev/${userName}"
              ];
            };
            vdirsyncer = {
              enable = true;
              metadata = [
                "color"
                "displayname"
              ];
              collections = [ "Persönlich" ];
            };
          };
        };
      };

      programs.vdirsyncer.enable = true;
      services.vdirsyncer.enable = true;

      systemd.user.services.vdirsyncer.Service = {
        ExecCondition =
          let
            awk = lib.getExe pkgs.gawk;
            gpg-connect-agent = lib.getExe' config.programs.gpg.package "gpg-connect-agent";
            rg = lib.getExe pkgs.ripgrep;
            pgrep = lib.getExe' pkgs.procps "pgrep";
          in
          ''
            /bin/sh -c "${pgrep} 'gpg-agent' &> /dev/null && ${gpg-connect-agent} 'keyinfo --list' /bye | ${awk} -F ' ' '{print $7}' | ${rg} 1"
          '';
        Restart = "on-failure";
        StartLimitBurst = 2;
        ExecStopPost = pkgs.writeShellScript "stop-post" ''
          # When it requires a discovery
          if [ "$SERVICE_RESULT" == "exit-code" ]; then
            ${lib.getExe config.services.vdirsyncer.package} discover --no-list
          fi
        '';
      };
    };
}
