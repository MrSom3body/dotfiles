{
  lib,
  isInstall,
  ...
}: {
  imports =
    [
      ./boot.nix
      ./console.nix
      ./locale.nix
      ./security.nix
      ./users.nix
    ]
    ++ (
      if isInstall
      then [./sops.nix]
      else []
    );

  documentation.dev.enable = true;

  # compresses half the ram for use as swap
  zramSwap.enable = true;

  # don't touch this
  system.stateVersion = lib.mkForce "24.05";
}
