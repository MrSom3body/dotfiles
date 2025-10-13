{ inputs, ... }:
{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        programs.hyprland = {
          enable = true;
          xwayland.enable = true;
          withUWSM = true;

          package = inputs.hyprland.packages.${pkgs.system}.default;
          portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
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
          let
            inherit (inputs.hyprpicker.packages.${pkgs.system}) hyprpicker;
          in
          builtins.attrValues {
            inherit (pkgs)
              brightnessctl
              nautilus
              pwvucontrol
              satty
              wl-clipboard
              wtype
              ;
          }
          ++
            # my packages
            builtins.attrValues {
              inherit (inputs.som3pkgs.packages.${pkgs.system})
                hyprcast
                touchpad-toggle
                wl-ocr
                ;
            }
          ++ [
            hyprpicker
            (inputs.hyprland-contrib.packages.${pkgs.system}.grimblast.override { inherit hyprpicker; })
          ];

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
