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
        {
          _args = [
            "SUPER + CTRL + Left"
            (lua ''hl.dsp.workspace.move({ monitor = "l" })'')
            { description = "Move workspace to left monitor"; }
          ];
        }
        {
          _args = [
            "SUPER + CTRL + Right"
            (lua ''hl.dsp.workspace.move({ monitor = "r" })'')
            { description = "Move workspace to right monitor"; }
          ];
        }
        {
          _args = [
            "SUPER + CTRL + Up"
            (lua ''hl.dsp.workspace.move({ monitor = "u" })'')
            { description = "Move workspace to top monitor"; }
          ];
        }
        {
          _args = [
            "SUPER + CTRL + Down"
            (lua ''hl.dsp.workspace.move({ monitor = "d" })'')
            { description = "Move workspace to bottom monitor"; }
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
            {
              _args = [
                "SUPER + ALT + code:1${toString i}"
                (lua ''
                  function()
                    hl.dispatch(hl.dsp.workspace.move({ workspace = ${toString ws}, monitor = "current" }))
                    hl.dispatch(hl.dsp.focus({ workspace = ${toString ws} }))
                  end
                '')
                { description = "Move workspace ${toString ws} to current monitor"; }
              ];
            }
          ]
        ) 9
      );
  };
}
