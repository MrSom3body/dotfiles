{...}: {
  imports = [
    ../../system/profiles/server.nix
    ./hardware-configuration.nix

    ../../system/services/openssh.nix
    ../../system/services/tailscale.nix
  ];

  services.ddns-updater.enable = true;
  security.tpm2.enable = true;
  powerManagement.enable = true;
}
