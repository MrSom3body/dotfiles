{
  flake.modules.homeManager.hyprland =
    { config, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
    in
    {
      wayland.windowManager.hyprland.settings = {
        curve = [
          {
            _args = [
              "bounce"
              {
                type = "spring";
                mass = 1;
                stiffness = 60;
                dampening = 11;
              }
            ];
          }
          {
            _args = [
              "slight_bounce"
              {
                type = "spring";
                mass = 1;
                stiffness = 80;
                dampening = 14;
              }
            ];
          }
        ];

        animation = [
          {
            leaf = "fade";
            enabled = true;
            speed = 4;
            bezier = "default";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 2;
            bezier = "default";
          }
          {
            leaf = "windows";
            enabled = true;
            speed = 8;
            spring = "bounce";
            style = "slide";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 2;
            spring = "slight_bounce";
            style = if layout == "scrolling" then "slidevert" else "slide";
          }
        ];
      };
    };
}
