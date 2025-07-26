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
  cfg' = config.programs.ghostty;
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
        gtk-single-instance = true;
        mouse-hide-while-typing = true;
        window-decoration = false;
        window-padding-balance = true;
        window-padding-x = 15;
        window-padding-y = 15;
      };
    };

    systemd.user.services.ghostty = {
      Unit = {
        Description = "Fast, native, feature-rich terminal emulator pushing modern features.";
        Documentation = "man:ghostty(1)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${cfg'.package}/bin/ghostty --gtk-single-instance=true --initial-window=false --quit-after-last-window-closed=false";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
