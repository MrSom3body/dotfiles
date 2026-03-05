{
  flake.modules.homeManager.hyprland =
    { config, lib, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
    in
    {
      config.wayland.windowManager.hyprland.settings.bindd = lib.optionals (layout == "dwindle") [
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

        # Resize window
        "SUPER CTRL, H, Increase window size to the left, resizeactive, -100 0"
        "SUPER CTRL, J, Increase window size to the bottom, resizeactive, 0 100"
        "SUPER CTRL, K, Increase window size to the top, resizeactive, 0 -100"
        "SUPER CTRL, L, Increase window size to the right, resizeactive, 100 0"
      ];
    };
}
