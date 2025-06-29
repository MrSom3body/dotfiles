{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.tokei;
in {
  options.my.programs.tokei = {
    enable = mkEnableOption "tokei";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.tokei];

    xdg.configFile."tokei.toml".text =
      # toml
      ''
        sort = "lines"
      '';
  };
}
