{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.pay-respects;
in {
  options.my.programs.pay-respects = {
    enable = mkEnableOption "pay-respects";
  };

  config = mkIf cfg.enable {
    programs.pay-respects = {
      enable = true;
      options = [
        "--alias"
        "f"
        "--nocnf"
      ];
    };
  };
}
