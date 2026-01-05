{ self, ... }:
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
      { config, pkgs, ... }:
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

        home.packages =
          builtins.attrValues {
            inherit (pkgs)
              brightnessctl
              nautilus
              pwvucontrol
              satty
              wl-clipboard
              wtype
              hyprpicker
              ;
          }
          ++
            # my packages
            builtins.attrValues {
              inherit (self.packages.${pkgs.stdenv.hostPlatform.system})
                hyprcast
                touchpad-toggle
                wl-ocr
                ;
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
}
