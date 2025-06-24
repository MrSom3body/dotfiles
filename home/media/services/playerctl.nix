{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.media;
in {
  config = mkIf cfg.enable {
    home.packages = [pkgs.playerctl];

    services.playerctld.enable = true;
  };
}
