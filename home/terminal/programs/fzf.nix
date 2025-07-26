{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.fzf;
in
{
  options.my.terminal.programs.fzf = {
    enable = mkEnableOption "the fzf program";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
    };
  };
}
