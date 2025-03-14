{...}: {
  imports = [
    ../../system/profiles/server.nix
    ./hardware-configuration.nix

    ../../system/services/openssh.nix
  ];

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
