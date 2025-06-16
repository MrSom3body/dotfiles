{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib) types;
  cfg = config.wayland.windowManager.hyprland;
in {
  imports = [
    ./settings.nix
    ./layouts
    ./binds.nix
    ./animations.nix
    ./permissions.nix
    ./pyprland.nix
    ./rules.nix
    ./plugins/hyprbars.nix
  ];

  options.my.wm.hyprland = {
    layout = mkOption {
      type = types.enum ["dwindle" "master" "scrolling"];
      default = "dwindle";
      description = "Switch between dwindle, master and scrolling layout";
    };
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;

      package = null;
      portalPackage = null;

      settings.permission = builtins.map (plugin: plugin + "/lib/lib${plugin.pname}.so, plugin, allow") cfg.plugins;
    };

    services = {
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
    };

    home.packages = let
      inherit (inputs.hyprpicker.packages.${pkgs.system}) hyprpicker;
    in
      builtins.attrValues {
        inherit
          (pkgs)
          brightnessctl
          nautilus
          nwg-displays
          satty
          wl-clipboard
          wtype
          ;
      }
      ++
      # my packages
      builtins.attrValues {
        inherit
          (pkgs)
          wl-ocr
          hyprcast
          ;
      }
      ++ [
        hyprpicker
        (inputs.hyprland-contrib.packages.${pkgs.system}.grimblast.override {inherit hyprpicker;})
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
}
