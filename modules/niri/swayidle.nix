{
  flake.modules.homeManager.niri = {
    services.swayidle = {
      enable = true;
      timeout = 300;
      actions = {
        lock = "swaylock -f";
        suspend = "systemctl suspend";
      };
    };
  };
}
