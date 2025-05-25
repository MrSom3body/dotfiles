{isInstall, ...}: {
  services.fwupd.enable = isInstall;
}
