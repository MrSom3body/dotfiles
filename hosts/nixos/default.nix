{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
    ../common/profiles/server.nix

    ../common/optional/services/openssh.nix
  ];

  disabledModules = [
    ../common/global/core/boot.nix
    ../common/global/services/tailscale.nix
  ];

  # Options to make my config override the iso one
  security.sudo.enable = lib.mkForce false;
  networking.wireless.enable = lib.mkForce false;

  nixpkgs.hostPlatform = "x86_64-linux";
}
