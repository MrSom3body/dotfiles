{
  flake.modules.homeManager.hyprland =
    { config, lib, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
    in
    {
      config.wayland.windowManager.hyprland.settings.bindd = lib.optionals (layout == "scrolling") [
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
}
