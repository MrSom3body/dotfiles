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
  inherit (lib) mkForce;
in {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")

    ../global

    ../optional/services/openssh.nix
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

  services.getty = {
    autologinUser = mkForce "karun";
    helpLine = mkForce ''
      The user "karun" has the fixed password "password". This
      password cannot be changed. SSH is already enabled, and the
      necessary keys have been added for remote login.
    '';
  };

  users.users.karun.initialPassword = "password";

  # Options to make my config override the iso one
  boot.supportedFilesystems.zfs = mkForce false;
  networking.wireless.enable = mkForce false;
  security.sudo.enable = mkForce false;
}
