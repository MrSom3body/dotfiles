{
  flake.modules.homeManager.hyprland =
    { lib, ... }:
    {
      wayland.windowManager.hyprland.settings.bind =
        let
          lua = lib.generators.mkLuaInline;
          desc = description: { inherit description; };
        in
        [
          # Controls
          {
            _args = [
              "SUPER + Q"
              (lua "hl.dsp.window.close()")
              (desc "Close focused window")
            ];
          }
          {
            _args = [
              "SUPER + W"
              (lua "hl.dsp.window.float()")
              (desc "Toggle floating")
            ];
          }
          {
            _args = [
              "SUPER + P"
              (lua "hl.dsp.window.pin()")
              (desc "Pin focused window")
            ];
          }

          # Window grouping
          {
            _args = [
              "SUPER + G"
              (lua "hl.dsp.group.toggle()")
              (desc "Toggle group")
            ];
          }
          {
            _args = [
              "SUPER + ALT + G"
              (lua "hl.dsp.window.move({ out_of_group = true })")
              (desc "Move out of group")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + G"
              (lua "hl.dsp.group.lock_active({ action = \"toggle\" })")
              (desc "Lock or unlock active group")
            ];
          }

          {
            _args = [
              "SUPER + ALT + H"
              (lua ''hl.dsp.window.move({ direction = "l", group_aware = true })'')
              (desc "Tile window left / enter/leave group")
            ];
          }
          {
            _args = [
              "SUPER + ALT + J"
              (lua ''hl.dsp.window.move({ direction = "d", group_aware = true })'')
              (desc "Tile window down / enter/leave group")
            ];
          }
          {
            _args = [
              "SUPER + ALT + K"
              (lua ''hl.dsp.window.move({ direction = "u", group_aware = true })'')
              (desc "Tile window up / enter/leave group")
            ];
          }
          {
            _args = [
              "SUPER + ALT + L"
              (lua ''hl.dsp.window.move({ direction = "r", group_aware = true })'')
              (desc "Tile window right / enter/leave group")
            ];
          }

          {
            _args = [
              "SUPER + TAB"
              (lua "hl.dsp.group.next()")
              (desc "Change active window in group right")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + TAB"
              (lua "hl.dsp.group.prev()")
              (desc "Change active window in group left")
            ];
          }

          # Floating windows
          {
            _args = [
              "SUPER + SHIFT + H"
              (lua "hl.dsp.window.move({ x = -100, y = 0, relative = true })")
              (desc "Move window left (floating)")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + J"
              (lua "hl.dsp.window.move({ x = 0, y = 100, relative = true })")
              (desc "Move window down (floating)")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + K"
              (lua "hl.dsp.window.move({ x = 0, y = -100, relative = true })")
              (desc "Move window up (floating)")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + L"
              (lua "hl.dsp.window.move({ x = 100, y = 0, relative = true })")
              (desc "Move window right (floating)")
            ];
          }
        ];
    };
}
