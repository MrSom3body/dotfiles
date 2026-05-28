{ lib, ... }:
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      settings.bind = [
        {
          _args = [
            "SUPER + S"
            (lib.generators.mkLuaInline ''hl.dsp.submap("system")'')
            { description = "Activate system submap"; }
          ];
        }
      ];

      submaps.system = {
        onDispatch = "reset";
        settings.bind =
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
            {
              _args = [
                "R"
                (lua ''hl.dsp.exec_cmd("uwsm app -- hyprcast")'')
                { description = "Start/stop screencast (without audio)"; }
              ];
            }
            {
              _args = [
                "SHIFT + R"
                (lua ''hl.dsp.exec_cmd("uwsm app -- hyprcast -a")'')
                { description = "Start/stop screencast (with audio)"; }
              ];
            }
            {
              _args = [
                "O"
                (lua ''hl.dsp.exec_cmd("wl-ocr -nc")'')
                { description = "Copy text from screen"; }
              ];
            }
            {
              _args = [
                "C"
                (lua ''hl.dsp.exec_cmd("${runOnce "hyprpicker -a"}")'')
                { description = "Open color picker"; }
              ];
            }
            {
              _args = [
                "V"
                (lua ''hl.dsp.exec_cmd("vicinae-vpnc")'')
                { description = "Connect/disconnect from a vpnc VPN"; }
              ];
            }
            {
              _args = [
                "M"
                (lua ''hl.dsp.exec_cmd("vicinae-monitors")'')
                { description = "Open monitor manager"; }
              ];
            }

            {
              _args = [
                "SHIFT + minus"
                (lua ''function() hl.config({["cursor.zoom_factor"] = 1}) end'')
                { description = "Reset zoom"; }
              ];
            }

            # Zoom in/out (repeating)
            {
              _args = [
                "plus"
                (lua ''function() hl.config({["cursor.zoom_factor"] = hl.get_config("cursor.zoom_factor") * 1.1}) end'')
                {
                  description = "Zoom in";
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "minus"
                (lua ''function() local f = hl.get_config("cursor.zoom_factor") * 0.9; hl.config({["cursor.zoom_factor"] = f < 1 and 1 or f}) end'')
                {
                  description = "Zoom out";
                  repeating = true;
                }
              ];
            }

            {
              _args = [
                "catchall"
                (lua ''hl.dsp.submap("reset")'')
                { release = true; }
              ];
            }
          ];
      };
    };
  };
}
