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

      systemd.user.services.vdirsyncer.Unit.After = [ "sops-nix.service" ];

      systemd.user.services.vdirsyncer.Service = {
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
