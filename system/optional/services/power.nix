{
  services = {
    logind.settings.Login.HandlePowerKey = "suspend";

    power-profiles-daemon.enable = true;

    upower.enable = true;
  };
}
