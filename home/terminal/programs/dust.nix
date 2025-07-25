{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.dust;
in
{
  options.my.terminal.programs.dust = {
    enable = mkEnableOption "dust, a disk usage tool";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.dust ];
    xdg.configFile."dust/config.toml".text =
      # toml
      ''
        reverse=false
      '';
  };
}
