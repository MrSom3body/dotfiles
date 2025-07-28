{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.zellij;
in
{
  options.my.terminal.programs.zellij = {
    enable = mkEnableOption "the zellij program";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };
  };
}
