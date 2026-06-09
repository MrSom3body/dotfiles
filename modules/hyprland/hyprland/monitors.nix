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

      workspace_rule = [
        {
          workspace = "1";
          monitor = "eDP-1";
          default = true;
        }
        {
          workspace = "2";
          monitor = "eDP-1";
          default = true;
        }
        {
          workspace = "3";
          monitor = "eDP-1";
          default = true;
        }
      ];
    };
  };
}
