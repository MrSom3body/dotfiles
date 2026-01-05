{
  flake.modules = {
    nixos.opentabletdriver = {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

    homeManager.opentabletdriver = {
      wayland.windowManager.hyprland.settings.permissions = [
        "opentabletdriver-virtual-keyboard, keyboard, allow"
      ];
    };
  };
}
