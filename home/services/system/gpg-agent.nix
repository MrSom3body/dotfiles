{pkgs, ...}: {
  services.gpg-agent = {
    enable = false;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
