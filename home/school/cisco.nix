{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.my.school.cisco;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ciscoPacketTracer8
    ];
  };
}
