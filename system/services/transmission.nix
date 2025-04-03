{
  services.transmission = {
    enable = true;
    settings = {
      speed-limit-up = 500;
      speed-limit-up-enabled = true;

      idle-seeding-limit = 180;
      idle-seeding-limit-enabled = true;

      ratio-limit = 2;
      ratio-limit-enabled = true;
    };
  };
}
