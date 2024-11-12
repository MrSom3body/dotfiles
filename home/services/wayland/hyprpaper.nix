{
  inputs,
  lib,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;

    package = inputs.hyprpaper.packages.${pkgs.system}.default;
  };

  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
}
