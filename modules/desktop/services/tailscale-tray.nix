{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      systemd.user.services.tailscale-systray = {
        Unit = {
          Description = "Tailscale System Tray";
          After = [ "systemd.service" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.tailscale}/bin/tailscale systray";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "default.target" ];
      };
    };
}
