{...}: {
  imports = [
    ../../system/profiles/workstation.nix
    ./hardware-configuration.nix
  ];

  services.openssh.enable = true;

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
