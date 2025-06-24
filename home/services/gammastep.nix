{
  services.gammastep = {
    enable = true;

    provider = "manual";
    # don't bother with it it isn't my real location
    latitude = 48.2083537;
    longitude = 16.3725042;

    settings.general.adjustment-method = "wayland";
  };
}
