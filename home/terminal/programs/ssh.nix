{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.ssh;
in
{
  options.my.terminal.programs.ssh = {
    enable = mkEnableOption "the ssh program";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks."*" = {
        setEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}
