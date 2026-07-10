{ lib, self, ... }: {
  flake.modules = {
    nixos.hyprland = {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };
    };

    homeManager.hyprland =
      { config, pkgs, ... }:
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
          home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.hypr-focus-or-launch ];

          wayland.windowManager.hyprland = {
            enable = true;
            systemd.enable = false;

            package = null;
            portalPackage = null;

            configType = "lua";

            settings.permission = map (plugin: {
              binary = lib.escapeRegex "${plugin}/lib/lib${plugin.pname}.so";
              type = "plugin";
              mode = "allow";
            }) cfg.plugins;
          };

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
