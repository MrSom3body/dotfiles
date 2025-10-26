{
  flake.modules.homeManager.desktop = {
    wayland.windowManager.hyprland.settings.bindd = [
      # Controls
      "SUPER, Q, Close focused window, killactive"
      "SUPER, F, Fullscreen focused window, fullscreen"
      "SUPER, I, Change split direction, togglesplit"
      "SUPER, W, Toggle floating, togglefloating"
      "SUPER, P, Pin focused window, pin"

      # Move window focus
      "SUPER, H, Focus window to the left, movefocus, l"
      "SUPER, J, Focus window to the bottom, movefocus, d"
      "SUPER, K, Focus window to the top, movefocus, u"
      "SUPER, L, Focus window to the right, movefocus, r"

      # Move window
      "SUPER SHIFT, H, Move window left (tiling), swapwindow, l"
      "SUPER SHIFT, J, Move window down (tiling), swapwindow, d"
      "SUPER SHIFT, K, Move window up (tiling), swapwindow, u"
      "SUPER SHIFT, L, Move window right (tiling), swapwindow, r"
      "SUPER SHIFT, H, Move window left (floating), moveactive, -100 0"
      "SUPER SHIFT, J, Move window down (floating), moveactive, 0 100"
      "SUPER SHIFT, K, Move window up (floating), moveactive, 0 -100"
      "SUPER SHIFT, L, Move window right (floating), moveactive, 100 0"

      # Resize window
      "SUPER CTRL, H, Increase window size to the left, resizeactive, -100 0"
      "SUPER CTRL, J, Increase window size to the bottom, resizeactive, 0 100"
      "SUPER CTRL, K, Increase window size to the top, resizeactive, 0 -100"
      "SUPER CTRL, L, Increase window size to the right, resizeactive, 100 0"

      # Window grouping
      "SUPER, G, Toggle group, togglegroup"
      "SUPER ALT, G, Move out of group, moveoutofgroup"
      "SUPER SHIFT, G, Lock or unlock active group, lockactivegroup, toggle"

      "SUPER ALT, H, Move window to group on left, moveintogroup, l"
      "SUPER ALT, J, Move window to group on bottom, moveintogroup, d"
      "SUPER ALT, K, Move window to group on top, moveintogroup, u"
      "SUPER ALT, L, Move window to group on right, moveintogroup, r"

      "SUPER, TAB, Change active window in group right, changegroupactive, f"
      "SUPER SHIFT, TAB, Change active window in group left, changegroupactive, b"
    ];
  };
}
