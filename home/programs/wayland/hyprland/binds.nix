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
      toggle = cmd: "pkill ${cmd} || uwsm app -- ${cmd}";
      toggleScript = cmd: script: "pkill ${cmd} || uwsm app -- ${script}";
      runOnce = cmd: "pgrep ${cmd} || uwsm app -- ${cmd}";
      hyprcast = "uwsm app -- ~/.config/hypr/scripts/hyprcast.fish";
    in
      [
        # Vesktop
        "CTRL SHIFT, M, Mute on vesktop, pass, ^(vesktop)$"
        "CTRL SHIFT, D, Deaf on vesktop, pass, ^(vesktop)$"

        # Open applications
        "$mainMod, RETURN, Open terminal, exec, uwsm app -- ${dotfiles.terminal}"
        "$mainMod, B, Open browser, exec, uwsm app -- ${dotfiles.browser}"
        "$mainMod, O, Open Obsidian, exec, uwsm app -- obsidian"
        "$mainMod, E, Open terminal terminal file manager, exec, uwsm app -- ${dotfiles.terminal} ${dotfiles.terminalFileManager}"
        "$mainMod SHIFT, E, Open file manager, exec, uwsm app -- ${dotfiles.fileManager}"
        ", XF86Calculator, Open calculator, exec, ${runOnce "gnome-calculator"}"

        # Launcher
        "$mainMod, D, Open application launcher, exec, ${toggle "fuzzel"}"
        # "$mainMod, TAB, Open window switcher, exec, ${toggle "rofi"} -show window"
        "$mainMod CTRL, Q, Open power menu, exec, ${toggleScript "fuzzel" "fuzzel-powermenu.fish"}"
        "$mainMod, PERIOD, Open symbols search, exec, ${toggleScript "fuzzel" "fuzzel-icons.fish"}"

        # Actions
        "$mainMod, Q, Close focused window, killactive"
        "$mainMod, F, Fullscreen focused window, fullscreen"
        "$mainMod, P, Pseudotile focused window (dwindle), pseudo"
        "$mainMod, W, Toggle floating, togglefloating"
        "$mainMod, I, Change split direction (dwindle), togglesplit"
        "$mainMod, N, Open notification center, exec, swaync-client -t"
        "$mainMod, ESCAPE, Lock screen, exec, ${runOnce "hyprlock"}"
        "$mainMod, C, Open color picker, exec, ${runOnce "hyprpicker -a"}"
        "$mainMod SHIFT, O, Ask ollama something, exec, uwsm app -- fish -c \"chat -fcs\""
        "$mainMod, G, Toggle group, togglegroup"
        "$mainMod SHIFT, N, Change active window in group right, changegroupactive, f"
        "$mainMod SHIFT, P, Change active window in group left, changegroupactive, b"

        # Clipboard
        "$mainMod, V, Show clipboard history, exec, ${toggleScript "fuzzel" "fuzzel-clipboard.fish"}"
        "$mainMod CTRL, V, Clear clipboard history, exec, uwsm app -- rm $XDG_CACHE_HOME/cliphist/db"

        # Screenshots
        ", PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze --notify copysave area ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
        "SHIFT, PRINT, Take screenshot of screen, exec, ${runOnce "grimblast"} --freeze save area - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"
        "$mainMod, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze --notify copysave screen ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"
        "$mainMod SHIFT, PRINT, Take screenshot of window, exec, ${runOnce "grimblast"} --freeze save screen - | satty -f - --fullscreen -o ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command wl-copy --save-after-copy"

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
        "$mainMod, T, Toggle Lunatask workspace, togglespecialworkspace, lunatask"
        "$mainMod SHIFT, T, Move focused window to Lunatask workspace, movetoworkspace, special:lunatask"

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
      ", Caps_Lock, exec, sleep 0.07; swayosd-client --caps-lock"

      # Num Lock
      ", Num_Lock, exec, sleep 0.07; swayosd-client --num-lock"
    ];
  };
}