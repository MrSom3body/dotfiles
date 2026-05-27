{
  flake.modules.homeManager.hyprland =
    { config, lib, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
      lua = lib.generators.mkLuaInline;
      desc = description: { inherit description; };
    in
    {
      config.wayland.windowManager.hyprland.settings.bind = lib.optionals (layout == "scrolling") [
        # Move window focus
        {
          _args = [
            "SUPER + H"
            (lua ''hl.dsp.layout("focus l")'')
            (desc "Focus column to the left")
          ];
        }
        {
          _args = [
            "SUPER + J"
            (lua ''hl.dsp.layout("focus d")'')
            (desc "Focus window below")
          ];
        }
        {
          _args = [
            "SUPER + K"
            (lua ''hl.dsp.layout("focus u")'')
            (desc "Focus window above")
          ];
        }
        {
          _args = [
            "SUPER + L"
            (lua ''hl.dsp.layout("focus r")'')
            (desc "Focus column to the right")
          ];
        }

        # Move window/column
        {
          _args = [
            "SUPER + SHIFT + H"
            (lua ''hl.dsp.layout("swapcol l")'')
            (desc "Move column left")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + J"
            (lua ''hl.dsp.window.swap({ direction = "d" })'')
            (desc "Move window down in column")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + K"
            (lua ''hl.dsp.window.swap({ direction = "u" })'')
            (desc "Move window up in column")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + L"
            (lua ''hl.dsp.layout("swapcol r")'')
            (desc "Move column right")
          ];
        }

        # Resize columns
        {
          _args = [
            "SUPER + CTRL + H"
            (lua ''hl.dsp.layout("colresize -0.2")'')
            (desc "Decrease column size")
          ];
        }
        {
          _args = [
            "SUPER + CTRL + J"
            (lua "hl.dsp.window.resize({ x = 0, y = 100, relative = true })")
            (desc "Increase window size to the bottom")
          ];
        }
        {
          _args = [
            "SUPER + CTRL + K"
            (lua "hl.dsp.window.resize({ x = 0, y = -100, relative = true })")
            (desc "Increase window size to the top")
          ];
        }
        {
          _args = [
            "SUPER + CTRL + L"
            (lua ''hl.dsp.layout("colresize +0.2")'')
            (desc "Increase column size")
          ];
        }

        # Promote windows
        {
          _args = [
            "SUPER + M"
            (lua ''hl.dsp.layout("promote")'')
            (desc "Expel window from column")
          ];
        }

        # Cycle preset column widths
        {
          _args = [
            "SUPER + R"
            (lua ''hl.dsp.layout("colresize +conf")'')
            (desc "Cycle column width")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + R"
            (lua ''hl.dsp.layout("colresize -conf")'')
            (desc "Cycle column width")
          ];
        }

        # Maximize/Fullscreen
        {
          _args = [
            "SUPER + F"
            (lua ''hl.dsp.window.fullscreen({ mode = "maximized" })'')
            (desc "Maximize focused column")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + F"
            (lua ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
            (desc "Fullscreen focused window")
          ];
        }
      ];
    };
}
