{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.tailray;
in {
  imports = [
    inputs.tailray.homeManagerModules.default
  ];

  options.my.services.tailray = {
    enable = mkEnableOption "the tailray service";
  };

  config = mkIf cfg.enable {
    services.tailray.enable = true;
    systemd.user.services.tailray.Unit.After = lib.mkForce "graphical-session.target";
  };
}
