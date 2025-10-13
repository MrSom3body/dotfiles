{
  flake.modules = {
    nixos.bluetooth = {
      hardware.bluetooth = {
        enable = true;
      };

      services.blueman.enable = true;
    };

    homeManager.bluetooth = {
      services.blueman-applet.enable = true;
    };
  };
}
