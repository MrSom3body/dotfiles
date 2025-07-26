{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.shell.bash;
in
{
  options.my.shell.bash = {
    enable = mkEnableOption "my bash shell";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
    };
  };
}
