{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        }
      ];
    };
  };
}
