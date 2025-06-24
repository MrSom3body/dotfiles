{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) types;

  inherit (lib) mkDefault;

  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;

  cfg = config.my.desktop;
in {
  imports = [
    ./hyprland
  ];

  options.my.desktop = {
    enable = mkEnableOption "a customized desktop";
    type = mkOption {
      type = types.enum ["Hyprland"];
      default = "Hyprland";
      description = "The desktop type you want to use";
    };
  };

  config = mkIf cfg.enable {
    my = {
      browsers.zen-browser = {
        enable = true;
        default = true;
      };
      media.enable = true;
      office.enable = true;
      utils.enable = true;

      programs = {
        fuzzel.enable = mkDefault true;
        waybar.enable = mkDefault true;
      };

      services = {
        cliphist.enable = mkDefault true;
        fnott.enable = mkDefault true;
        gammastep.enable = mkDefault true;
        swayosd.enable = mkDefault true;
      };
    };

    my.desktop.hyprland.enable = mkIf (cfg.type == "Hyprland") true;
  };
}
