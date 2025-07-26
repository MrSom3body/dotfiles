{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my.media;
in
{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.playerctl ];

    services.playerctld.enable = true;

    systemd.user.services.playerctld.Service.Restart = lib.mkForce "on-failure";
  };
}
