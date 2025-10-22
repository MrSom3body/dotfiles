{ self, ... }:
{
  flake.modules.homeManager.auto-kbd-bl =
    { pkgs, ... }:
    {
      systemd.user.services.auto-kbd-bl = {
        Unit = {
          Description = "Auto Keyboard Backlight";
        };

        Service = {
          Type = "simple";
          ExecStart = "${self.packages.${pkgs.system}.auto-kbd-bl}/bin/auto-kbd-bl";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "default.target" ];
      };
    };
}
