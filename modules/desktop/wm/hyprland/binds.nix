{ lib, config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings = {
        "$mainMod" = "SUPER";

        binddm = [
          "$mainMod, mouse:272, Move window with ${
            config.wayland.windowManager.hyprland.settings."$mainMod"
          } and left click, movewindow"
          "$mainMod, mouse:273, Resize window with ${
            config.wayland.windowManager.hyprland.settings."$mainMod"
          } and right click, resizewindow"
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
            "$mainMod, RETURN, Open terminal, exec, ${terminal}"
            "$mainMod, B, Open browser, exec, uwsm app -- ${meta.programs.browser}"
            "$mainMod, E, Open terminal terminal file manager, exec, uwsm app -- xdg-terminal-exec ${meta.programs.terminalFileManager}"
            "$mainMod SHIFT, E, Open file manager, exec, uwsm app -- ${meta.programs.fileManager}"
            ", XF86Calculator, Open calculator, exec, ${runOnce "gnome-calculator"}"

            # Vesktop
            "CTRL SHIFT, M, Mute on vesktop, pass, class:^(vesktop)$"
            "CTRL SHIFT, D, Deafen on vesktop, pass, class:^(vesktop)$"

            # Launcher
            "$mainMod, D, Open application launcher, exec, ${toggle "fuzzel"}"
            "$mainMod, MINUS, Open display manager, exec, ${toggleScript "fuzzel" "fuzzel-displays"}"
            "$mainMod, SPACE, Open file/directory picker, exec, ${toggleScript "fuzzel" "fuzzel-files"}"
            "$mainMod, TAB, Open window switcher, exec, ${toggleScript "fuzzel" "fuzzel-windows"}"
            "ALT, TAB, Open window switcher, exec, ${toggleScript "fuzzel" "fuzzel-windows"}"
            "$mainMod CTRL, Q, Open power menu, exec, ${toggleScript "fuzzel" "fuzzel-actions"}"
            "$mainMod, PERIOD, Open symbols search, exec, ${toggleScript "fuzzel" "fuzzel-icons"}"
            "$mainMod, odiaeresis, Connect/disconnect from a vpnc VPN, exec, ${toggleScript "fuzzel" "fuzzel-vpnc"}"

            # Window actions
            "$mainMod, Q, Close focused window, killactive"
            "$mainMod, F, Fullscreen focused window, fullscreen"
            "$mainMod, W, Toggle floating, togglefloating"
            "$mainMod, P, Pin focused window, pin"

            # Other actions
            "$mainMod, O, Copy text from screen, exec, wl-ocr -nc"
            "$mainMod, ESCAPE, Lock screen, exec, loginctl lock-session"
            "$mainMod, C, Open color picker, exec, ${runOnce "hyprpicker -a"}"
            # "$mainMod SHIFT, O, Ask ollama something, exec, uwsm app -- fish -c \"chat -fcs\""

            "$mainMod, I, Change split direction (dwindle), togglesplit"

            # Move window focus
            "$mainMod, H, Focus window to the left, movefocus, l"
            "$mainMod, J, Focus window to the bottom, movefocus, d"
            "$mainMod, K, Focus window to the top, movefocus, u"
            "$mainMod, L, Focus window to the right, movefocus, r"

            # Move window
            "$mainMod SHIFT, H, Move window left (tiling), swapwindow, l"
            "$mainMod SHIFT, J, Move window down (tiling), swapwindow, d"
            "$mainMod SHIFT, K, Move window up (tiling), swapwindow, u"
            "$mainMod SHIFT, L, Move window right (tiling), swapwindow, r"
            "$mainMod SHIFT, H, Move window left (floating), moveactive, -100 0"
            "$mainMod SHIFT, J, Move window down (floating), moveactive, 0 100"
            "$mainMod SHIFT, K, Move window up (floating), moveactive, 0 -100"
            "$mainMod SHIFT, L, Move window right (floating), moveactive, 100 0"

            # Resize window
            "$mainMod CTRL, H, Increase window size to the left, resizeactive, -100 0"
            "$mainMod CTRL, J, Increase window size to the bottom, resizeactive, 0 100"
            "$mainMod CTRL, K, Increase window size to the top, resizeactive, 0 -100"
            "$mainMod CTRL, L, Increase window size to the right, resizeactive, 100 0"

            # Window grouping
            "$mainMod, G, Toggle group, togglegroup"
            "$mainMod SHIFT, G, Lock or unlock active group, lockactivegroup, toggle"
            "$mainMod SHIFT, N, Change active window in group right, changegroupactive, f"
            "$mainMod SHIFT, P, Change active window in group left, changegroupactive, b"

            # Notifications
            "$mainMod, N, Open notification action, exec, fnottctl actions"
            "$mainMod CTRL, N, Dismiss notification, exec, fnottctl dismiss"
            "$mainMod ALT, N, Toggle do not disturb mode, exec, fnott-dnd"

            # Clipboard
            "$mainMod, V, Show clipboard history, exec, ${toggleScript "fuzzel" "fuzzel-clipboard"}"
            "$mainMod CTRL, V, Clear clipboard history, exec, uwsm app -- rm $XDG_CACHE_HOME/cliphist/db"

            # Screenshots
            ", PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze --notify copysave area ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
            "SHIFT, PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze save area - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"
            "$mainMod, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze --notify copysave screen ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
            "$mainMod SHIFT, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze save screen - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"

            # Screencast
            "$mainMod, R, Start/stop screencast (without audio), exec, uwsm app -- hyprcast"
            "$mainMod SHIFT, R, Start/stop screencast (with audio), exec, uwsm app -- hyprcast -a"

            # Special workspaces
            "$mainMod, A, Toggle special workspace, togglespecialworkspace, magic"
            "$mainMod SHIFT, A, Move focused window to special workspace, movetoworkspace, special:magic"

            "$mainMod, S, Toggle Spotify workspace, togglespecialworkspace, spotify"
            "$mainMod SHIFT, S, Move focused window to Spotify workspace, movetoworkspace, special:spotify"
            "$mainMod, M, Toggle Monitor workspace, togglespecialworkspace, monitor"
            "$mainMod SHIFT, M, Move focused window to Monitor workspace, movetoworkspace, special:monitor"
            "$mainMod, X, Toggle Discord workspace, togglespecialworkspace, discord"
            "$mainMod SHIFT, X, Move focused window to Discord workspace, movetoworkspace, special:discord"
            "$mainMod, T, Toggle todoist workspace, togglespecialworkspace, todoist"
            "$mainMod SHIFT, T, Move focused window to todoist workspace, movetoworkspace, special:todoist"

            # Switch workspaces
            "$mainMod, Prior, Switch to next workspace, workspace, r-1"
            "$mainMod, Next, Switch to previous workspace, workspace, r+1"

            "$mainMod, mouse_down, Switch to next workspace, workspace, e+1"
            "$mainMod, mouse_up, Switch to previous workspace, workspace, e-1"
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mainMod, code:1${toString i}, Switch to workspace ${toString ws}, workspace, ${toString ws}"
                "$mainMod SHIFT, code:1${toString i}, Move focused window to workspace ${toString ws}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          ));

        bindl =
          let
            playerctl = lib.getExe pkgs.playerctl;
          in
          [
            # Audio control
            ", XF86AudioPlay, exec, ${playerctl} play-pause"
            ", XF86AudioPause, exec, ${playerctl} pause"
            ", XF86AudioNext, exec, ${playerctl} next"
            ", XF86AudioPrev, exec, ${playerctl} previous"
            ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
            ", XF86AudioMicMute, exec, swayosd-client --output-input mute-toggle"
          ];

        bindlr = [
          # Touchpad toggle
          ", XF86TouchpadToggle, exec, touchpad-toggle"

          # Caps Lock
          ", Caps_Lock, exec, swayosd-client --caps-lock"

          # Num Lock
          ", Num_Lock, exec, swayosd-client --num-lock"
        ];

        bindel = [
          # Volume control
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"

          # Brightness control
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ];
      };
    };
}
