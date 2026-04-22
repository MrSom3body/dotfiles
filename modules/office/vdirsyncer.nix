{
  flake.modules.homeManager.office =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
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
