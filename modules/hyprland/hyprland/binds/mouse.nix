{
  flake.modules.homeManager.hyprland =
    { lib, ... }:
    {
      wayland.windowManager.hyprland.settings.bind =
        let
          lua = lib.generators.mkLuaInline;
        in
        [
          {
            _args = [
              "SUPER + mouse:272"
              (lua "hl.dsp.window.drag()")
              {
                mouse = true;
                description = "Move window with Super and left click";
              }
            ];
          }
          {
            _args = [
              "SUPER + mouse:273"
              (lua "hl.dsp.window.resize()")
              {
                mouse = true;
                description = "Resize window with Super and right click";
              }
            ];
          }

          {
            _args = [
              "SUPER + mouse_down"
              (lua ''hl.dsp.focus({ workspace = "e+1" })'')
              { description = "Switch to next workspace"; }
            ];
          }
          {
            _args = [
              "SUPER + mouse_up"
              (lua ''hl.dsp.focus({ workspace = "e-1" })'')
              { description = "Switch to previous workspace"; }
            ];
          }
        ];
    };
}
