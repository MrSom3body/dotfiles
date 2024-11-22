{lib, ...}: {
  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  systemd.user.services = {
    cliphist.Unit.After = lib.mkForce ["graphical-session.target"];
    cliphist-images.Unit.After = lib.mkForce ["graphical-session.target"];
  };
}
