{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;

  cfg = config.my.terminal.programs.ntfy;
in {
  options.my.terminal.programs.ntfy = {
    enable = mkEnableOption "my ntfy config";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.ntfy-sh];
    xdg.configFile."ntfy/client.yml".text =
      # yaml
      ''
        default-host: https://ntfy.sndh.dev
      '';
  };
}
