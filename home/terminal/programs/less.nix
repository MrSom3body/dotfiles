{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.less;
in
{
  options.my.terminal.programs.less = {
    enable = mkEnableOption "the less program";
  };

  config = mkIf cfg.enable {
    programs.less.enable = true;
    home.sessionVariables.LESS = "-R";
  };
}
