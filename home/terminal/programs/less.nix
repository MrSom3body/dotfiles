{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.less;
in {
  options.my.programs.less = {
    enable = mkEnableOption "the less program";
  };

  config = mkIf cfg.enable {
    programs.less.enable = true;
    home.sessionVariables.LESS = "-R --mouse --wheel-lines=3";
  };
}
