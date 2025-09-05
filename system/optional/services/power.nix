{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  services = {
    logind.settings.Login = {
      HandlePowerKey = "suspend-then-hibernate";
      HandleLidSwitch = "suspend-then-hibernate";
    };

    power-profiles-daemon.enable = true;

    upower.enable = true;
  };
}
