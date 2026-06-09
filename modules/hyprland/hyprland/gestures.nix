{
  flake.modules.homeManager.hyprland =
    { lib, config, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
      lua = lib.generators.mkLuaInline;
    in
    {
      wayland.windowManager.hyprland.settings = {
        gesture = [
          {
            fingers = 4;
            direction = "pinch";
            action = lua ''function() hl.exec_cmd("loginctl lock-session") end'';
          }
          {
            fingers = 3;
            direction = "horizontal";
            action = if layout == "scrolling" then "scroll_move" else "workspace";
          }
        ]
        ++ lib.optionals (layout == "scrolling") [
          {
            fingers = 3;
            direction = "vertical";
            action = "workspace";
          }
        ];
      };
    };
}
