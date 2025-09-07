{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.my.school;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ciscoPacketTracer8
    ];
  };
}
