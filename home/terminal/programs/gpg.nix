{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.gpg;
in {
  options.my.programs.gpg = {
    enable = mkEnableOption "gpg";
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
    };
  };
}
