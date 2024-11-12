{
  pkgs,
  lib,
  ...
}: {
  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
    indicator = true;
  };

  systemd.user.services = {
    kdeconnect.Unit.After = lib.mkForce ["graphical-session.target"];
    kdeconnect-indicator.Unit.After = lib.mkForce ["graphical-session.target"];
  };
}
