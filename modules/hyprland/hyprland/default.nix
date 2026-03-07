{ lib, ... }:
{
  flake.modules = {
    nixos.hyprland = {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };
    };

    homeManager.hyprland =
      { config, ... }:
      let
        cfg = config.wayland.windowManager.hyprland;
      in
      {
        options.wayland.windowManager.hyprland.layout = lib.mkOption {
          type = lib.types.enum [
            "dwindle"
            "scrolling"
            "master"
          ];
          default = "dwindle";
        };

        config = {
          wayland.windowManager.hyprland = {
            enable = true;
            systemd.enable = false;

            package = null;
            portalPackage = null;

            settings.permission = map (
              plugin: plugin + "/lib/lib${plugin.pname}.so, plugin, allow"
            ) cfg.plugins;
          };

          services.network-manager-applet.enable = true;

          home.file.".config/hypr/scripts" = {
            source = ./scripts;
          };

          dconf.settings = {
            "org/gnome/desktop/wm/preferences" = {
              button-layout = "':'";
            };
          };
        };
      };
  };
}
