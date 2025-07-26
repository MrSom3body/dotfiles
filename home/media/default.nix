{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.media;
in
{
  imports = [
    ./programs
    ./services
  ];

  options.my.media = {
    enable = mkEnableOption "media viewing related programs";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        # audio control
        pwvucontrol
        # images
        inkscape
        krita
        loupe
        ;
    };
  };
}
