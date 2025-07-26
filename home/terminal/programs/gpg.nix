{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.gpg;
in
{
  options.my.terminal.programs.gpg = {
    enable = mkEnableOption "gpg";
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
    };
  };
}
