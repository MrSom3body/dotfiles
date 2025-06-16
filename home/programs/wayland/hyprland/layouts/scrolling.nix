{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = lib.mkIf (config.my.wm.hyprland.layout == "scrolling") {
    plugins = [inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling];

    settings = {
      plugin.hyprscrolling = {
        fullscreen_on_one_column = true;
        focus_fit_method = 1;
      };

      bindd = [
        # Move window focus
        "$mainMod, H, Focus window to the left, layoutmsg, focus l"
        "$mainMod, J, Focus window to the bottom, layoutmsg, focus d"
        "$mainMod, K, Focus window to the top, layoutmsg, focus u"
        "$mainMod, L, Focus window to the right, layoutmsg, focus r"

        # Move window
        "$mainMod SHIFT, H, Move window left, layoutmsg, movewindowto l"
        "$mainMod SHIFT, J, Move window down, layoutmsg, movewindowto d"
        "$mainMod SHIFT, K, Move window up, layoutmsg, movewindowto u"
        "$mainMod SHIFT, L, Move window right, layoutmsg, movewindowto r"

        # Resize window
        # TODO make J & K work
        "$mainMod CTRL, H, Decrease column size, layoutmsg, colresize -conf"
        "$mainMod CTRL, J, Increase window size to the bottom, resizeactive, 0 100"
        "$mainMod CTRL, K, Increase window size to the top, resizeactive, 0 -100"
        "$mainMod CTRL, L, Increase column size, layoutmsg, colresize +conf"

        # Promote to column
        "$mainMod CTRL, PERIOD, Promote to own column, layoutmsg, promote"
      ];
    };
  };
}
