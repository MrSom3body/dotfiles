{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) types;

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

  config = mkIf (cfg.enable && cfg.type == "Hyprland") {
    my.desktop.hyprland.enable = true;
  };
}
