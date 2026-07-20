{
  flake.modules.homeManager.desktop = {
    services.wlsunset = {
      enable = true;
      sunset = "21:00";
      sunrise = "06:00";
      # duration = 1800; # TODO uncomment when https://github.com/nix-community/home-manager/pull/9691 gets merged
      temperature = {
        day = 6500;
        night = 3700;
      };
    };
  };
}
