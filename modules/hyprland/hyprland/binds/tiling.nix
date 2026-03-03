{
  flake.modules.homeManager.hyprland =
    { config, lib, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
    in
    {
      options.wayland.windowManager.hyprland.layout = lib.mkOption {
        type = lib.types.enum [
          "dwindle"
          "scrolling"
          "master"
        ];
        default = "dwindle";
      };

      config.wayland.windowManager.hyprland.settings = {
        general.layout = layout;

        bindd = [
          # Controls
          "SUPER, Q, Close focused window, killactive"
          "SUPER, F, Fullscreen focused window, fullscreen"
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
        ]
        ++ lib.optionals (layout == "dwindle") [
          "SUPER, I, Change split direction, layoutmsg, swapsplit"

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
        ]
        ++ lib.optionals (layout == "scrolling") [
          # Move window focus
          "SUPER, H, Focus column to the left, layoutmsg, focus l"
          "SUPER, J, Focus window below, layoutmsg, focus d"
          "SUPER, K, Focus window above, layoutmsg, focus u"
          "SUPER, L, Focus column to the right, layoutmsg, focus r"

          # Move window/column
          "SUPER SHIFT, H, Move column left, layoutmsg, swapcol l"
          "SUPER SHIFT, J, Move window down in column, swapwindow, d"
          "SUPER SHIFT, K, Move window up in column, swapwindow, u"
          "SUPER SHIFT, L, Move column right, layoutmsg, swapcol r"

          # Resize columns
          "SUPER CTRL, H, Decrease column size, layoutmsg, colresize -0.2"
          "SUPER CTRL, J, Increase window size to the bottom, resizeactive, 0 100"
          "SUPER CTRL, K, Increase window size to the top, resizeactive, 0 -100"
          "SUPER CTRL, L, Increase column size, layoutmsg, colresize +0.2"

          # Promote windows
          "SUPER, M, Expel window from column, layoutmsg, promote"

          # Cycle preset column widths
          "SUPER, R, Cycle column width, layoutmsg, colresize +conf"
          "SUPER SHIFT, R, Cycle column width, layoutmsg, colresize -conf"

          # Maximize/Fullscreen
          "SUPER, F, Maximize focused column, fullscreen, 1"
          "SUPER SHIFT, F, Fullscreen focused window, fullscreen, 0"

          # Center focused column
          "SUPER, C, Toggle center/fit focused column, layoutmsg, togglefit"
        ];
      };
    };
}
