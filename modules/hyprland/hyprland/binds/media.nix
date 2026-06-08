{ self, lib, ... }: {
  flake.modules.homeManager.hyprland = { config, pkgs, ... }: {
    wayland.windowManager.hyprland.settings.bind =
      let
        lua = lib.generators.mkLuaInline;
        swayosd = lib.getExe' config.services.swayosd.package "swayosd-client";
        playerctl = lib.getExe config.services.playerctld.package;
        touchpadToggle = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.touchpad-toggle;
      in
      [
        # Audio control (locked)
        {
          _args = [
            "XF86AudioPlay"
            (lua ''hl.dsp.exec_cmd("${playerctl} play-pause")'')
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioPause"
            (lua ''hl.dsp.exec_cmd("${playerctl} play-pause")'')
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (lua ''hl.dsp.exec_cmd("${playerctl} next")'')
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (lua ''hl.dsp.exec_cmd("${playerctl} previous")'')
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lua ''hl.dsp.exec_cmd("${swayosd} --output-volume mute-toggle")'')
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioMicMute"
            (lua ''hl.dsp.exec_cmd("${swayosd} --output-input mute-toggle")'')
            { locked = true; }
          ];
        }

        # Touchpad toggle (locked + release)
        {
          _args = [
            "XF86TouchpadToggle"
            (lua ''hl.dsp.exec_cmd("${touchpadToggle}")'')
            {
              locked = true;
              release = true;
            }
          ];
        }

        # Caps Lock / Num Lock (locked + release)
        {
          _args = [
            "Caps_Lock"
            (lua ''hl.dsp.exec_cmd("${swayosd} --caps-lock")'')
            {
              locked = true;
              release = true;
            }
          ];
        }
        {
          _args = [
            "Num_Lock"
            (lua ''hl.dsp.exec_cmd("${swayosd} --num-lock")'')
            {
              locked = true;
              release = true;
            }
          ];
        }

        # Volume control (locked + repeating)
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lua ''hl.dsp.exec_cmd("${swayosd} --output-volume raise")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lua ''hl.dsp.exec_cmd("${swayosd} --output-volume lower")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "ALT + XF86AudioRaiseVolume"
            (lua ''hl.dsp.exec_cmd("${swayosd} --output-volume +1")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "ALT + XF86AudioLowerVolume"
            (lua ''hl.dsp.exec_cmd("${swayosd} --output-volume -1")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }

        # Brightness control (locked + repeating)
        {
          _args = [
            "XF86MonBrightnessUp"
            (lua ''hl.dsp.exec_cmd("${swayosd} --brightness raise")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (lua ''hl.dsp.exec_cmd("${swayosd} --brightness lower")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "ALT + XF86MonBrightnessUp"
            (lua ''hl.dsp.exec_cmd("${swayosd} --brightness +1")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "ALT + XF86MonBrightnessDown"
            (lua ''hl.dsp.exec_cmd("${swayosd} --brightness -1")'')
            {
              locked = true;
              repeating = true;
            }
          ];
        }
      ];
  };
}
