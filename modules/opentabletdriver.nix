{ lib, ... }:
{
  flake.modules = {
    nixos.opentabletdriver = {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

    homeManager.opentabletdriver = {
      wayland.windowManager.hyprland.settings.permission = lib.mkBefore [
        "opentabletdriver-virtual-keyboard, keyboard, allow"
      ];
    };
  };
}
