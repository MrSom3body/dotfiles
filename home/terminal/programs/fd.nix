{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.fd;
in {
  options.my.programs.fd = {
    enable = mkEnableOption "the fd program";
  };

  config = mkIf cfg.enable {
    programs.fd = {
      enable = true;
      hidden = false;
      ignores = [".git/" "venv/"];
    };
  };
}
