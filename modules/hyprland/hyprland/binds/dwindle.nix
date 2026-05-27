{
  flake.modules.homeManager.hyprland =
    { config, lib, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
      lua = lib.generators.mkLuaInline;
      desc = description: { inherit description; };
    in
    {
      config.wayland.windowManager.hyprland.settings.bind = lib.optionals (layout == "dwindle") [
        {
          _args = [
            "SUPER + F"
            (lua ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
            (desc "Fullscreen focused window")
          ];
        }
        {
          _args = [
            "SUPER + I"
            (lua ''hl.dsp.layout("swapsplit")'')
            (desc "Change split direction")
          ];
        }

        # Move window focus
        {
          _args = [
            "SUPER + H"
            (lua ''hl.dsp.focus({ direction = "l" })'')
            (desc "Focus window to the left")
          ];
        }
        {
          _args = [
            "SUPER + J"
            (lua ''hl.dsp.focus({ direction = "d" })'')
            (desc "Focus window to the bottom")
          ];
        }
        {
          _args = [
            "SUPER + K"
            (lua ''hl.dsp.focus({ direction = "u" })'')
            (desc "Focus window to the top")
          ];
        }
        {
          _args = [
            "SUPER + L"
            (lua ''hl.dsp.focus({ direction = "r" })'')
            (desc "Focus window to the right")
          ];
        }

        # Move window
        {
          _args = [
            "SUPER + SHIFT + H"
            (lua ''hl.dsp.window.swap({ direction = "l" })'')
            (desc "Move window left (tiling)")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + J"
            (lua ''hl.dsp.window.swap({ direction = "d" })'')
            (desc "Move window down (tiling)")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + K"
            (lua ''hl.dsp.window.swap({ direction = "u" })'')
            (desc "Move window up (tiling)")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + L"
            (lua ''hl.dsp.window.swap({ direction = "r" })'')
            (desc "Move window right (tiling)")
          ];
        }

      ];
    };
}
