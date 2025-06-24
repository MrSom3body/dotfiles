{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.power-monitor;
in {
  options.my.services.power-monitor = {
    enable = mkEnableOption "the power-monitor service";
  };

  config = mkIf cfg.enable {
    systemd.user.services.power-monitor = {
      Unit = {
        Description = "Power Monitor";
        After = ["power-profiles-daemon.service"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.power-monitor}/bin/power-monitor";
        Restart = "on-failure";
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
