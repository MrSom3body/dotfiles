{lib, ...}: {
  imports = [
    ./boot.nix
    ./console.nix
    ./locale.nix
    ./security.nix
    ./users.nix
    ./sops.nix
  ];

  documentation.dev.enable = true;

  # compresses half the ram for use as swap
  zramSwap.enable = true;

  # don't touch this
  system.stateVersion = lib.mkForce "24.05";
}
