{
  flake.modules = {
    nixos.bluetooth = {
      hardware.bluetooth = {
        enable = true;
      };

      services.blueman = {
        enable = true;
        # TODO remove when https://github.com/NixOS/nixpkgs/issues/514705 gets resolved
        withApplet = false;
      };
    };

    homeManager.bluetooth = {
      services.blueman-applet.enable = true;
    };
  };
}
