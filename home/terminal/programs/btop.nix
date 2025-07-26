{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.btop;
in
{
  options.my.terminal.programs.btop = {
    enable = mkEnableOption "the btop monitor";
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;

      settings = {
        vim_keys = true;
      };
    };
  };
}
