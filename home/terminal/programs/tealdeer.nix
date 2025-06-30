{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.tealdeer;
in {
  options.my.terminal.programs.tealdeer = {
    enable = mkEnableOption "tealdeer";
  };

  config = mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}
