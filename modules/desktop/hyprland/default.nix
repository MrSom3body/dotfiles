{
  flake.modules = {
    nixos.desktop = {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };

      # tell Electron/Chromium to run on Wayland
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };

    homeManager.desktop =
      { config, ... }:
      let
        cfg = config.wayland.windowManager.hyprland;
      in
      {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;

          package = null;
          portalPackage = null;

          settings.permission = builtins.map (
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
}
