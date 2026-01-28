{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      animation = [
        "fade, 1, 4, default"

        "border, 1, 2, default"
        "windows, 1, 3, default, slide"

        "workspaces, 1, 2, default, slide"
      ];
    };
  };
}
