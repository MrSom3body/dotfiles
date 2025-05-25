{
  self,
  lib,
  config,
  pkgs,
  modulesPath,
  settings,
  ...
}: let
  inherit (lib) mkImageMediaOverride;
in {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")

    ../../system/global

    ../../system/optional/services/openssh.nix
  ];

  isoImage = let
    inherit (settings) hostname;
    rev = self.shortRev or "${builtins.substring 0 8 self.lastModifiedDate}-dirty";
    # $hostname-$release-$rev-$arch
    name = "${hostname}-${config.system.nixos.release}-${rev}-${pkgs.stdenv.hostPlatform.uname.processor}";
  in {
    isoBaseName = mkImageMediaOverride name;
    isoName = mkImageMediaOverride "${name}.iso";
    volumeID = mkImageMediaOverride name;
  };

  nixpkgs.overlays = [
    (_final: super: {
      espeak = super.espeak.override {mbrolaSupport = false;};
    })
  ];

  # Options to make my config override the iso one
  security.sudo.enable = lib.mkForce false;
  networking.wireless.enable = lib.mkForce false;
}
