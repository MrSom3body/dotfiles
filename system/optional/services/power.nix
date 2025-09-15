{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  services = {
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "suspend";
    };

    power-profiles-daemon.enable = true;

    upower.enable = true;
  };
}
