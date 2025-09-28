{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.hyprpaper;
in
{
  options.my.services.hyprpaper = {
    enable = mkEnableOption "the hyprpaper service";
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;

      package = inputs.hyprpaper.packages.${pkgs.system}.default;
    };
  };
}
