{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
    ../../system/profiles/server.nix

    ../../system/optional/services/openssh.nix
  ];

  disabledModules = [
    ../../system/global/core/boot.nix
    ../../system/global/services/tailscale.nix
  ];

  # Options to make my config override the iso one
  security.sudo.enable = lib.mkForce false;
  networking.wireless.enable = lib.mkForce false;

  nixpkgs.hostPlatform = "x86_64-linux";
}
