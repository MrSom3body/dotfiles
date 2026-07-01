{
  flake.modules.homeManager.desktop = {
    services.wlsunset = {
      enable = true;
      sunset = "21:00";
      sunrise = "06:00";
      temperature = {
        day = 6500;
        night = 3700;
      };
    };
  };
}
