{
  flake.modules.homeManager.hyprland = { lib, ... }: {
    wayland.windowManager.hyprland.settings.bind =
      let
        lua = lib.generators.mkLuaInline;
        shorten = s: builtins.substring 0 14 s;
        runOnce =
          program:
          let
            prog = shorten program;
          in
          "pgrep ${prog} || uwsm app -- ${program}";
      in
      [
        # Launcher
        {
          _args = [
            "SUPER + D"
            (lua ''hl.dsp.exec_cmd("vicinae toggle")'')
            { description = "Open application launcher"; }
          ];
        }
        {
          _args = [
            "ALT + TAB"
            (lua ''hl.dsp.exec_cmd("vicinae vicinae://launch/wm/switch-windows")'')
            { description = "Open window switcher"; }
          ];
        }
        {
          _args = [
            "SUPER + PERIOD"
            (lua ''hl.dsp.exec_cmd("vicinae vicinae://launch/core/search-emojis")'')
            { description = "Open symbols search"; }
          ];
        }

        # Clipboard
        {
          _args = [
            "SUPER + V"
            (lua ''hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history")'')
            { description = "Show clipboard history"; }
          ];
        }
        {
          _args = [
            "SUPER + CTRL + V"
            (lua ''hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/clear-history")'')
            { description = "Clear clipboard history"; }
          ];
        }

        # Notifications
        {
          _args = [
            "SUPER + COMMA"
            (lua ''hl.dsp.exec_cmd("fnottctl actions")'')
            { description = "Open notification action"; }
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + COMMA"
            (lua ''hl.dsp.exec_cmd("fnottctl dismiss")'')
            { description = "Dismiss oldest notification"; }
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + COMMA"
            (lua ''hl.dsp.exec_cmd("fnottctl dismiss all")'')
            {
              description = "Dismiss all notifications";
              non_consuming = true;
            }
          ];
        }
        {
          _args = [
            "SUPER + CTRL + COMMA"
            (lua ''hl.dsp.exec_cmd("fnott-dnd")'')
            { description = "Toggle do not disturb mode"; }
          ];
        }

        # Screenshots
        {
          _args = [
            "PRINT"
            (lua ''hl.dsp.exec_cmd("${runOnce "grimblast"} --freeze --notify copysave area")'')
            { description = "Take screenshot of a window"; }
          ];
        }
        {
          _args = [
            "SHIFT + PRINT"
            (lua ''hl.dsp.exec_cmd("${runOnce "grimblast"} --freeze edit area")'')
            { description = "Take and edit screenshot of a window"; }
          ];
        }
        {
          _args = [
            "SUPER + PRINT"
            (lua ''hl.dsp.exec_cmd("${runOnce "grimblast"} --freeze --notify copysave output")'')
            { description = "Take screenshot of a screen"; }
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + PRINT"
            (lua ''hl.dsp.exec_cmd("${runOnce "grimblast"} --freeze edit output")'')
            { description = "Take and edit screenshot of a screen"; }
          ];
        }

        # Lock screen (locked)
        {
          _args = [
            "SUPER + ESCAPE"
            (lua ''hl.dsp.exec_cmd("loginctl lock-session")'')
            {
              description = "Lock screen";
              locked = true;
            }
          ];
        }
      ];
  };
}
