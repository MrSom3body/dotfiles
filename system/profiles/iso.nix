{
  self,
  lib,
  config,
  inputs,
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
    rev = self.shortRev or "${builtins.substring 0 8 self.lastModifiedDate}";
    inherit (config.system.nixos) release;
    arch = pkgs.stdenv.hostPlatform.uname.processor;

    fixedParts = "-${release}-${rev}-${arch}";
    fixedLen = builtins.stringLength fixedParts;

    # Max length for hostname to keep volumeID < 32
    maxHostnameLen =
      if fixedLen < 32
      then 32 - fixedLen
      else 0;

    shortHostname =
      if builtins.stringLength hostname > maxHostnameLen
      then builtins.substring 0 maxHostnameLen hostname
      else hostname;

    name = hostname + fixedParts;
  in {
    isoBaseName = mkImageMediaOverride name;
    isoName = mkImageMediaOverride (name + ".iso");
    volumeID = mkImageMediaOverride (shortHostname + fixedParts);
  };

  environment.systemPackages = [
    inputs.disko.packages.${pkgs.system}.default
  ];

  nixpkgs.overlays = [
    (_final: super: {
      espeak = super.espeak.override {mbrolaSupport = false;};
    })
  ];

  # Options to make my config override the iso one
  boot.supportedFilesystems.zfs = lib.mkForce false;
  networking.wireless.enable = lib.mkForce false;
  security.sudo.enable = lib.mkForce false;
}
