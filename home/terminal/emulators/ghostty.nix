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
  cfg = config.my.terminal.emulators.ghostty;
in
{
  options.my.terminal.emulators.ghostty = {
    enable = mkEnableOption "the ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.system}.default;
      settings = {
        font-feature = [ "ss06" ];
        mouse-hide-while-typing = true;
        window-decoration = false;
        window-padding-balance = true;
        window-padding-x = 15;
        window-padding-y = 15;

        quit-after-last-window-closed = true;
        quit-after-last-window-closed-delay = "5m";
      };
    };
  };
}
