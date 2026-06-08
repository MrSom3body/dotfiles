{ lib, ... }: {
  flake.modules = {
    nixos.opentabletdriver = {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

    homeManager.opentabletdriver = {
      wayland.windowManager.hyprland.settings.permission = lib.mkBefore [
        {
          binary = "opentabletdriver-virtual-keyboard";
          type = "keyboard";
          mode = "allow";
        }
      ];
    };
  };
}
