{
  config,
  dotfiles,
  ...
}: {
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

    bindd = let
      runOnce = cmd: "pkill ${cmd} || ${cmd}";
      hyprcast = "~/.config/hypr/scripts/hyprcast.fish";
    in
      [
        # Vesktop
        "CTRL SHIFT, M, Mute on vesktop, pass, ^(vesktop)$"
        "CTRL SHIFT, D, Deaf on vesktop, pass, ^(vesktop)$"

        # Open applications
        "$mainMod, T, Open terminal, exec, ${dotfiles.terminal}"
        "$mainMod, B, Open browser, exec, ${dotfiles.browser}"
        "$mainMod, O, Open obsidian, exec, obsidian"
        "$mainMod, E, Open terminal terminal file manager, exec, ${dotfiles.terminal} ${dotfiles.terminalFileManager}"
        "$mainMod SHIFT, E, Open file manager, exec, ${dotfiles.fileManager}"

        # Launcher
        "$mainMod, D, Open application launcher, exec, ${runOnce "rofi"} -show drun"
        "$mainMod, TAB, Open window switcher, exec, ${runOnce "rofi"} -show window"
        "$mainMod CTRL, Q, Open power menu, exec, ${runOnce "rofi"} -show powermenu -modes powermenu"
        "$mainMod, SPACE, Open file browser, exec, ${runOnce "rofi"} -show filebrowser"
        "$mainMod, PERIOD, Open symbols search, exec, pkill rofi || BEMOJI_PICKER_CMD=\"rofi -no-show-icons -dmenu\" bemoji -cn"

        # Actions
        "$mainMod, Q, Close focused window, killactive"
        "$mainMod, F, Fullscreen focused window, fullscreen"
        "$mainMod, P, Pseudotile focused window (dwindle), pseudo"
        "$mainMod, W, Toggle floating, togglefloating"
        "$mainMod, I, Change split direction (dwindle), togglesplit"
        "$mainMod, N, Open notification center, exec, swaync-client -t"
        "$mainMod, ESCAPE, Lock screen, exec, pgrep hyprlock || hyprlock"
        "$mainMod, C, Open color picker, exec, hyprpicker -a"

        # Clipboard
        "$mainMod, V, Show clipboard history, exec, ${runOnce "rofi"} -modi clipboard:cliphist-rofi-img -show clipboard"
        "$mainMod CTRL, V, Clear clipboard history, exec, cliphist wipe"

        # Screenshots
        ", PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --notify copysave area"
        "$mainMod, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --notify copysave screen"

        # Screencast
        "$mainMod, R, Start/stop screencast, exec, ${hyprcast}"

        # Move window focus
        "$mainMod, H, Focus window to the left, movefocus, l"
        "$mainMod, J, Focus window to the bottom, movefocus, d"
        "$mainMod, K, Focus window to the top, movefocus, u"
        "$mainMod, L, Focus window to the right, movefocus, r"

        # Move window
        "$mainMod SHIFT, H, Move window left, swapwindow, l"
        "$mainMod SHIFT, J, Move window down, swapwindow, d"
        "$mainMod SHIFT, K, Move window up, swapwindow, u"
        "$mainMod SHIFT, L, Move window right, swapwindow, r"

        # Resize window
        "$mainMod CTRL, H, Increase window size to the left, resizeactive, -100 0"
        "$mainMod CTRL, J, Increase window size to the bottom, resizeactive, 0 100"
        "$mainMod CTRL, K, Increase window size to the top, resizeactive, 0 -100"
        "$mainMod CTRL, L, Increase window size to the right, resizeactive, 100 0"

        # Special workspaces
        "$mainMod, A, Toggle special workspace, togglespecialworkspace, special"
        "$mainMod SHIFT, A, Move focused window to special workspace, movetoworkspace, special"

        "$mainMod, S, Toggle Spotify workspace, togglespecialworkspace, spotify"
        "$mainMod SHIFT, S, Move focused window to Spotify workspace, movetoworkspace, special:spotify"
        "$mainMod, M, Toggle Monitor workspace, togglespecialworkspace, monitor"
        "$mainMod SHIFT, M, Move focused window to Monitor workspace, movetoworkspace, special:monitor"
        "$mainMod, X, Toggle Discord workspace, togglespecialworkspace, discord"
        "$mainMod SHIFT, X, Move focused window to Discord workspace, movetoworkspace, special:discord"

        # Switch workspaces
        "$mainMod, Prior, Switch to next workspace, workspace, r-1"
        "$mainMod, Next, Switch to previous workspace, workspace, r+1"

        "$mainMod, mouse_down, Switch to next workspace, workspace, e+1"
        "$mainMod, mouse_up, Switch to previous workspace, workspace, e-1"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, Switch to workspace ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, Move focused window to workspace ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10
      ));

    # Player control
    bindl = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    bindel = [
      # Volume control
      ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
      ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, swayosd-client --output-input mute-toggle"

      # Brightness control
      ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

      # Caps Lock
      ", Caps_Lock, exec, sleep 0.2; swayosd-client --caps-lock"

      # Num Lock
      ", Num_Lock, exec, sleep 0.2; swayosd-client --num-lock"
    ];
  };
}
