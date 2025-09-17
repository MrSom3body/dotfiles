{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
    HibernateMode=shutdown
  '';

  services = {
    logind.settings.Login = {
      HandlePowerKey = "supend-then-hibernate";
      HandleLidSwitch = "suspend-then-hibernate";
    };

    power-profiles-daemon.enable = true;

    upower.enable = true;
  };
}
