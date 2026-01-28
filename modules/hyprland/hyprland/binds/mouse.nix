{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      binddm = [
        "SUPER, mouse:272, Move window with Super and left click, movewindow"
        "SUPER, mouse:273, Resize window with Super and right click, resizewindow"
      ];

      bindd = [
        "SUPER, mouse_down, Switch to next workspace, workspace, e+1"
        "SUPER, mouse_up, Switch to previous workspace, workspace, e-1"
      ];
    };
  };
}
