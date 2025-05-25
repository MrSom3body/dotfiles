{
  lib,
  pkgs,
  isInstall,
  ...
}: {
  boot = {
    bootspec.enable = true;

    initrd = {
      systemd.enable = true;
    };

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "preempt=full"
    ];

    loader = lib.mkIf isInstall {
      # systemd-boot on UEFI
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;
  };
}
