{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.todoist-electron ];

      wayland.windowManager.hyprland.settings.exec-once = [ "[silent] uwsm app -- todoist-electron" ];
    };
}
