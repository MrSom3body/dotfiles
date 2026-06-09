{
  flake.modules.homeManager.hyprland =
    { lib, ... }:
    let
      lua = lib.generators.mkLuaInline;
    in
    {
      wayland.windowManager.hyprland.settings = {
        on = [
          {
            _args = [
              "hyprland.start"
              (lua /* lua */ ''
                function()
                  hl.exec_cmd("uwsm finalize")
                  hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 1")
                end'')
            ];
          }
        ];
      };
    };
}
