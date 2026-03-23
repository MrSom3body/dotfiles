{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      bindd = [
        # Controls
        "SUPER, Q, Close focused window, killactive"
        "SUPER, W, Toggle floating, togglefloating"
        "SUPER, P, Pin focused window, pin"

        # Window grouping
        "SUPER, G, Toggle group, togglegroup"
        "SUPER ALT, G, Move out of group, moveoutofgroup"
        "SUPER SHIFT, G, Lock or unlock active group, lockactivegroup, toggle"

        "SUPER ALT, H, Move window to group on left, movewindoworgroup, l"
        "SUPER ALT, J, Move window to group on bottom, movewindoworgroup, d"
        "SUPER ALT, K, Move window to group on top, movewindoworgroup, u"
        "SUPER ALT, L, Move window to group on right, movewindoworgroup, r"

        "SUPER, TAB, Change active window in group right, changegroupactive, f"
        "SUPER SHIFT, TAB, Change active window in group left, changegroupactive, b"

        # Floating windows
        "SUPER SHIFT, H, Move window left (floating), moveactive, -100 0"
        "SUPER SHIFT, J, Move window down (floating), moveactive, 0 100"
        "SUPER SHIFT, K, Move window up (floating), moveactive, 0 -100"
        "SUPER SHIFT, L, Move window right (floating), moveactive, 100 0"
      ];
    };
  };
}
