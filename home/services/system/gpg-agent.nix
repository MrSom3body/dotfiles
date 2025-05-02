{pkgs, ...}: {
  services.gpg-agent = {
    enable = false;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
