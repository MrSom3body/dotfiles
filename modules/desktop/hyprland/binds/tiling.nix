{
  flake.modules.homeManager.desktop = {
    wayland.windowManager.hyprland.settings.bindd = [
      # Controls
      "$mainMod, Q, Close focused window, killactive"
      "$mainMod, F, Fullscreen focused window, fullscreen"
      "$mainMod, I, Change split direction, togglesplit"
      "$mainMod, W, Toggle floating, togglefloating"
      "$mainMod, P, Pin focused window, pin"

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
      "$mainMod ALT, G, Move out of group, moveoutofgroup"
      "$mainMod SHIFT, G, Lock or unlock active group, lockactivegroup, toggle"

      "$mainMod ALT, H, Move window to group on left, moveintogroup, l"
      "$mainMod ALT, J, Move window to group on bottom, moveintogroup, d"
      "$mainMod ALT, K, Move window to group on top, moveintogroup, u"
      "$mainMod ALT, L, Move window to group on right, moveintogroup, r"

      "$mainMod SHIFT, N, Change active window in group right, changegroupactive, f"
      "$mainMod SHIFT, P, Change active window in group left, changegroupactive, b"
    ];
  };
}
