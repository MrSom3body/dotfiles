{
  flake.modules.homeManager.hyprland = { lib, ... }: {
    wayland.windowManager.hyprland.settings.bind =
      let
        lua = lib.generators.mkLuaInline;
      in
      [
        {
          _args = [
            "SUPER + Prior"
            (lua ''hl.dsp.focus({ workspace = "r-1" })'')
            { description = "Switch to previous workspace"; }
          ];
        }
        {
          _args = [
            "SUPER + Next"
            (lua ''hl.dsp.focus({ workspace = "r+1" })'')
            { description = "Switch to next workspace"; }
          ];
        }
      ]
      ++ builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            {
              _args = [
                "SUPER + code:1${toString i}"
                (lua "hl.dsp.focus({ workspace = ${toString ws} })")
                { description = "Switch to workspace ${toString ws}"; }
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + code:1${toString i}"
                (lua "hl.dsp.window.move({ workspace = ${toString ws} })")
                { description = "Move focused window to workspace ${toString ws}"; }
              ];
            }
          ]
        ) 9
      );
  };
}
