{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
        };

        Install = {
          WantedBy = [ config.wayland.systemd.target ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
}
