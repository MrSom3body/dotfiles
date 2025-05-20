{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")

    ../../system/global/core/security.nix

    ../../system/global/network

    ../../system/global/hardware

    ../../system/global/services/dbus.nix

    ../../system/global/nix
    ../../system/global/programs/command-not-found.nix

    ../../system/optional/services/openssh.nix
  ];

  users.users.karun = {
    isNormalUser = true;
    description = "Karun Sandhu";
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
    ];
  };

  # Options to make my config override the iso one
  security.sudo.enable = lib.mkForce false;
  networking.wireless.enable = lib.mkForce false;

  nixpkgs.hostPlatform = "x86_64-linux";
}
