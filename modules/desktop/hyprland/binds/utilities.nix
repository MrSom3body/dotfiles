{
  flake.modules.homeManager.desktop = {
    wayland.windowManager.hyprland.settings = {
      bindd =
        let
          shorten = s: builtins.substring 0 14 s;
          toggleScript =
            program: script:
            let
              prog = shorten program;
            in
            "pkill ${prog} || uwsm app -- ${script}";
          runOnce =
            program:
            let
              prog = shorten program;
            in
            "pgrep ${prog} || uwsm app -- ${program}";
        in
        [
          # Launcher
          "SUPER, D, Open application launcher, exec, vicinae toggle"
          "SUPER, MINUS, Open display manager, exec, ${toggleScript "fuzzel" "fuzzel-displays"}" # TODO replace with vicinae
          "SUPER, SPACE, Open file/directory picker, exec, vicinae vicinae://extensions/vicinae/files/search"
          "ALT, TAB, Open window switcher, exec, vicinae vicinae://extensions/vicinae/wm/switch-windows"
          "SUPER, PERIOD, Open symbols search, exec, vicinae vicinae://extensions/vicinae/core/search-emojis"
          "SUPER, odiaeresis, Connect/disconnect from a vpnc VPN, exec, ${toggleScript "fuzzel" "fuzzel-vpnc"}" # TODO replace with vicinae

          # Clipboard
          "SUPER, V, Show clipboard history, exec, vicinae vicinae://extensions/vicinae/clipboard/history"
          "SUPER CTRL, V, Clear clipboard history, exec, vicinae vicinae://extensions/vicinae/clipboard/clear"

          # Notifcations
          "SUPER, COMMA, Open notification action, exec, fnottctl actions"
          "SUPER SHIFT, COMMA, Dismiss oldest notification, exec, fnottctl dismiss"
          "SUPER CTRL, COMMA, Toggle do not disturb mode, exec, fnott-dnd"

          # Screenshots
          ", PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze --notify copysave area"
          "SHIFT, PRINT, Take and edit screenshot of screen, exec, ${runOnce "grimblast"} --freeze edit area"
          "SUPER, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze --notify copysave screen"
          "SUPER SHIFT, PRINT, Take and edit screenshot of window, exec, ${runOnce "grimblast"} --freeze edit screen"

          # Screencast
          "SUPER, R, Start/stop screencast (without audio), exec, uwsm app -- hyprcast"
          "SUPER SHIFT, R, Start/stop screencast (with audio), exec, uwsm app -- hyprcast -a"

          # Other stuff
          "SUPER, O, Copy text from screen, exec, wl-ocr -nc"
          "SUPER, C, Open color picker, exec, ${runOnce "hyprpicker -a"}"
          # "SUPER SHIFT, O, Ask ollama something, exec, uwsm app -- fish -c \"chat -fcs\""
        ];

      binddo = [
        "SUPER SHIFT, COMMA, Dismiss all notifications, exec, fnottctl dismiss all"
      ];

      binddl = [
        # TODO move back to bindd when https://github.com/hyprwm/hyprlock/issues/793 gets resolved
        "SUPER, ESCAPE, Lock screen, exec, loginctl lock-session"
      ];
    };
  };
}
