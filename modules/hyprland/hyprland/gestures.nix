{
  flake.modules.homeManager.hyprland =
    { lib, config, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
      luaFunc =
        func:
        lib.generators.mkLuaInline ''
          function()
            ${func}
          end
        '';
    in
    {
      wayland.windowManager.hyprland.settings = {
        gesture = [
          {
            fingers = 4;
            direction = "pinchin";
            action = luaFunc ''hl.exec_cmd("loginctl lock-session")'';
          }
          {
            fingers = 3;
            direction = "swipe";
            action = "move";
          }
          {
            fingers = 4;
            direction = "horizontal";
            action = if layout == "scrolling" then "scroll_move" else "workspace";
          }
        ]
        ++ lib.optionals (layout == "scrolling") [
          {
            fingers = 4;
            direction = "vertical";
            action = "workspace";
          }
          {
            fingers = 3;
            direction = "pinchout";
            action = luaFunc ''hl.dsp.layout("promote")'';
          }
        ];
      };
    };
}
