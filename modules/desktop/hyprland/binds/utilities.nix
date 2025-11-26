_: {
  flake.modules.homeManager.desktop = {
    wayland.windowManager.hyprland.settings = {
      bindd =
        let
          shorten = s: builtins.substring 0 14 s;
          toggle =
            program:
            let
              prog = shorten program;
            in
            "pkill ${prog} || uwsm app -- ${program}";
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
          "SUPER, D, Open application launcher, exec, ${toggle "fuzzel"}"
          "SUPER, MINUS, Open display manager, exec, ${toggleScript "fuzzel" "fuzzel-displays"}"
          "SUPER, SPACE, Open file/directory picker, exec, ${toggleScript "fuzzel" "fuzzel-files"}"
          "ALT, TAB, Open window switcher, exec, ${toggleScript "fuzzel" "fuzzel-windows"}"
          "SUPER CTRL, Q, Open power menu, exec, ${toggleScript "fuzzel" "fuzzel-actions"}"
          "SUPER, PERIOD, Open symbols search, exec, ${toggleScript "fuzzel" "fuzzel-icons"}"
          "SUPER, odiaeresis, Connect/disconnect from a vpnc VPN, exec, ${toggleScript "fuzzel" "fuzzel-vpnc"}"

          # Clipboard
          "SUPER, V, Show clipboard history, exec, ${toggleScript "fuzzel" "fuzzel-clipboard"}"
          "SUPER CTRL, V, Clear clipboard history, exec, uwsm app -- rm $XDG_CACHE_HOME/cliphist/db"

          # Notifcations
          "SUPER, COMMA, Open notification action, exec, fnottctl actions"
          "SUPER SHIFT, COMMA, Dismiss oldest notification, exec, fnottctl dismiss"
          "SUPER CTRL, COMMA, Toggle do not disturb mode, exec, fnott-dnd"

          # Screenshots
          ", PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze --notify copysave area ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
          "SHIFT, PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze save area - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"
          "SUPER, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze --notify copysave screen ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
          "SUPER SHIFT, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze save screen - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"

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
