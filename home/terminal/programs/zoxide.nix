{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.zoxide;
in {
  options.my.programs.zoxide = {
    enable = mkEnableOption "the zoxide program";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };
}
