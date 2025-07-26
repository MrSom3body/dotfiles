{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my.office;
in
{
  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        scroll-page-aware = "true";
        scroll-full-overlap = "0.01";
        scroll-step = "100";
      };
    };
  };
}
