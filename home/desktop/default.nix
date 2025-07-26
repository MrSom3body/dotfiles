{
  lib,
  config,
  osConfig ? null,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) types;

  inherit (lib) mkDefault;

  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;

  cfg = config.my.desktop;
in
{
  imports = [
    ./hyprland
    ./xdg.nix
  ];

  options.my.desktop = {
    enable = mkEnableOption "a customized desktop";
    type = mkOption {
      type = types.enum [ "Hyprland" ];
      default = "Hyprland";
      description = "The desktop type you want to use";
    };
  };

  config = mkIf cfg.enable {
    my = {
      desktop.xdg.enable = true;
      browsers.zen-browser = {
        enable = true;
        default = true;
      };
      media.enable = true;
      office.enable = true;
      utils.enable = true;

      styling.enable = true;

      terminal.emulators.foot.enable = mkDefault true;

      programs = {
        fuzzel.enable = mkDefault true;
        waybar.enable = mkDefault true;
      };

      services = {
        cliphist.enable = mkDefault true;
        fnott.enable = mkDefault true;
        gammastep.enable = mkDefault true;
        kdeconnect.enable = mkDefault true;
        polkit.enable = mkDefault true;
        swayosd.enable = mkDefault true;
        tailray.enable = mkDefault (if osConfig != null then osConfig.services.tailscale.enable else false);
        udiskie.enable = mkDefault true;
      };
    };

    my.desktop.hyprland.enable = mkIf (cfg.type == "Hyprland") true;
  };
}
