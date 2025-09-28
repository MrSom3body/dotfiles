{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.cliphist;
in
{
  options.my.services.cliphist = {
    enable = mkEnableOption "the cliphist service";
  };

  config = mkIf cfg.enable {
    services.cliphist = {
      enable = true;
      allowImages = true;
    };
  };
}
