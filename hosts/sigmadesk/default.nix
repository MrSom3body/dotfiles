{...}: {
  imports = [
    ../../system/profiles/workstation.nix
    ./hardware-configuration.nix
  ];

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
