{
  lib,
  settings,
  isInstall,
  ...
}: {
  imports =
    [
      ./boot.nix
      ./locale.nix
      ./security.nix
      ./users.nix

      ../nix
    ]
    ++ (
      if isInstall
      then [./sops.nix]
      else []
    );

  documentation.dev.enable = true;

  services.xserver.xkb.options = "caps:swapescape";

  console = {
    earlySetup = true;
  };

  networking.hostName = settings.hostname;

  # compresses half the ram for use as swap
  zramSwap.enable = true;

  # don't touch this
  system.stateVersion = lib.mkForce "24.05";
}
