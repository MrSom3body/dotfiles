{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  flake.modules.nixos.iso = {
    system.autoUpgrade.enable = mkForce false; # really not needed on an ISO

    # overrides needed for my config to work with the iso template
    networking.networkmanager.enable = mkForce false;
    boot.supportedFilesystems.zfs = mkForce false;
    security = {
      sudo.enable = false;
      sudo-rs.wheelNeedsPassword = false;
    };
  };
}
