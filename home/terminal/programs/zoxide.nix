{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.zoxide;
in
{
  options.my.terminal.programs.zoxide = {
    enable = mkEnableOption "the zoxide program";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
