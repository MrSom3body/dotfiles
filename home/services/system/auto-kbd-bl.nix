{pkgs, ...}: {
  systemd.user.services.auto-kbd-bl = {
    Unit = {
      Description = "Auto Keyboard Backlight";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.auto-kbd-bl}/bin/auto-kbd-bl";
      Restart = "on-failure";
    };

    Install.WantedBy = ["default.target"];
  };
}
