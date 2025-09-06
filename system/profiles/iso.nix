{
  lib,
  config,
  inputs,
  pkgs,
  modulesPath,
  settings,
  ...
}:
let
  inherit (lib) mkImageMediaOverride;
  inherit (lib) mkDefault;
  inherit (lib) mkForce;
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")

    ../global

    ../optional/services/openssh.nix
  ];

  my = {
    users.isInstall = mkDefault false;
    boot.isInstall = mkDefault false;
    sops.enable = mkDefault false;
    home-manager.enable = mkDefault false;
  };

  isoImage =
    let
      inherit (settings) hostname;
      rev = inputs.self.shortRev or "${builtins.substring 0 8 inputs.self.lastModifiedDate}";
      inherit (config.system.nixos) release;
      arch = pkgs.stdenv.hostPlatform.uname.processor;

      fixedParts = "-${release}-${rev}-${arch}";
      fixedLen = builtins.stringLength fixedParts;

      # Max length for hostname to keep volumeID < 32
      maxHostnameLen = if fixedLen < 32 then 32 - fixedLen else 0;

      shortHostname =
        if builtins.stringLength hostname > maxHostnameLen then
          builtins.substring 0 maxHostnameLen hostname
        else
          hostname;

      name = hostname + fixedParts;
    in
    {
      isoBaseName = mkImageMediaOverride name;
      isoName = mkImageMediaOverride (name + ".iso");
      volumeID = mkImageMediaOverride (shortHostname + fixedParts);
    };

  environment.systemPackages = [
    inputs.disko.packages.${pkgs.system}.default
  ];

  nixpkgs.overlays = [
    (_final: super: {
      espeak = super.espeak.override { mbrolaSupport = false; };
    })
  ];

  services = {
    fwupd.enable = false;
    tailscale.enable = false;
    getty = {
      autologinUser = mkForce "karun";
      helpLine = mkForce (
        ''
          The "karun" and "root" accounts have empty passwords.

          To log in over ssh you must set a password for either "karun" or "root"
          with `passwd` (prefix with `sudo` for "root"), or add your public key to
          /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys.

          If you need a wireless connection, type
          `sudo systemctl start wpa_supplicant` and configure a
          network using `wpa_cli`. See the NixOS manual for details.
        ''
        + lib.optionalString config.services.xserver.enable ''

          Type `sudo systemctl start display-manager' to
          start the graphical user interface.
        ''
      );
    };
  };

  # Options to make my config override the iso one
  boot.supportedFilesystems.zfs = mkForce false;
  networking.wireless.enable = mkForce false;
  security = {
    sudo.enable = false;
    sudo-rs.wheelNeedsPassword = false;
  };
}
