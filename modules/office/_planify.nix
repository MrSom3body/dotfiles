{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.planify ];

      wayland.windowManager.hyprland.settings.bindd = [
        "SUPER, SPACE, Open Planify, exec, io.github.alainm23.planify.quick-add"
      ];

      xdg.autostart.entries = [ "${pkgs.planify}/share/applications/io.github.alainm23.planify.desktop" ];
    };
}
