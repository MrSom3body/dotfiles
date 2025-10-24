{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.desktop = {
    wayland.windowManager.hyprland.settings = {
      binddm = [
        "SUPER, mouse:272, Move window with Super and left click, movewindow"
        "SUPER, mouse:273, Resize window with Super and right click, resizewindow"
      ];

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

          terminal =
            if meta.programs.terminal == "ghostty" then
              "ghostty +new-window"
            else
              "uwsm app -- ${meta.programs.terminal}";
        in
        [
          # Open applications
          "SUPER, RETURN, Open terminal, exec, ${terminal}"
          "SUPER, B, Open browser, exec, uwsm app -- ${meta.programs.browser}"
          "SUPER, E, Open terminal terminal file manager, exec, uwsm app -- xdg-terminal-exec ${meta.programs.terminalFileManager}"
          "SUPER SHIFT, E, Open file manager, exec, uwsm app -- ${meta.programs.fileManager}"
          ", XF86Calculator, Open calculator, exec, ${runOnce "gnome-calculator"}"

          # Vesktop
          "CTRL SHIFT, M, Mute on vesktop, pass, class:^(vesktop)$"
          "CTRL SHIFT, D, Deafen on vesktop, pass, class:^(vesktop)$"

          # Launcher
          "SUPER, D, Open application launcher, exec, ${toggle "fuzzel"}"
          "SUPER, MINUS, Open display manager, exec, ${toggleScript "fuzzel" "fuzzel-displays"}"
          "SUPER, SPACE, Open file/directory picker, exec, ${toggleScript "fuzzel" "fuzzel-files"}"
          "SUPER, TAB, Open window switcher, exec, ${toggleScript "fuzzel" "fuzzel-windows"}"
          "ALT, TAB, Open window switcher, exec, ${toggleScript "fuzzel" "fuzzel-windows"}"
          "SUPER CTRL, Q, Open power menu, exec, ${toggleScript "fuzzel" "fuzzel-actions"}"
          "SUPER, PERIOD, Open symbols search, exec, ${toggleScript "fuzzel" "fuzzel-icons"}"
          "SUPER, odiaeresis, Connect/disconnect from a vpnc VPN, exec, ${toggleScript "fuzzel" "fuzzel-vpnc"}"

          # Other actions
          "SUPER, O, Copy text from screen, exec, wl-ocr -nc"
          "SUPER, ESCAPE, Lock screen, exec, loginctl lock-session"
          "SUPER, C, Open color picker, exec, ${runOnce "hyprpicker -a"}"
          # "SUPER SHIFT, O, Ask ollama something, exec, uwsm app -- fish -c \"chat -fcs\""

          # Notifications
          "SUPER, N, Open notification action, exec, fnottctl actions"
          "SUPER CTRL, N, Dismiss notification, exec, fnottctl dismiss"
          "SUPER ALT, N, Toggle do not disturb mode, exec, fnott-dnd"

          # Clipboard
          "SUPER, V, Show clipboard history, exec, ${toggleScript "fuzzel" "fuzzel-clipboard"}"
          "SUPER CTRL, V, Clear clipboard history, exec, uwsm app -- rm $XDG_CACHE_HOME/cliphist/db"

          # Screenshots
          ", PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze --notify copysave area ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
          "SHIFT, PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze save area - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"
          "SUPER, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze --notify copysave screen ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
          "SUPER SHIFT, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze save screen - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"

          # Screencast
          "SUPER, R, Start/stop screencast (without audio), exec, uwsm app -- hyprcast"
          "SUPER SHIFT, R, Start/stop screencast (with audio), exec, uwsm app -- hyprcast -a"

          # Special workspaces
          "SUPER, A, Toggle special workspace, togglespecialworkspace, magic"
          "SUPER SHIFT, A, Move focused window to special workspace, movetoworkspace, special:magic"

          "SUPER, S, Toggle Spotify workspace, togglespecialworkspace, spotify"
          "SUPER SHIFT, S, Move focused window to Spotify workspace, movetoworkspace, special:spotify"
          "SUPER, M, Toggle Monitor workspace, togglespecialworkspace, monitor"
          "SUPER SHIFT, M, Move focused window to Monitor workspace, movetoworkspace, special:monitor"
          "SUPER, X, Toggle Discord workspace, togglespecialworkspace, discord"
          "SUPER SHIFT, X, Move focused window to Discord workspace, movetoworkspace, special:discord"
          "SUPER, T, Toggle todoist workspace, togglespecialworkspace, todoist"
          "SUPER SHIFT, T, Move focused window to todoist workspace, movetoworkspace, special:todoist"

          # Switch workspaces
          "SUPER, Prior, Switch to next workspace, workspace, r-1"
          "SUPER, Next, Switch to previous workspace, workspace, r+1"

          "SUPER, mouse_down, Switch to next workspace, workspace, e+1"
          "SUPER, mouse_up, Switch to previous workspace, workspace, e-1"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "SUPER, code:1${toString i}, Switch to workspace ${toString ws}, workspace, ${toString ws}"
              "SUPER SHIFT, code:1${toString i}, Move focused window to workspace ${toString ws}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));
    };
  };
}
