{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  flake.modules.nixos.iso = {
    system.autoUpgrade.enable = mkForce false; # really not needed on an ISO

    # overrides needed for my config to work with the iso template
    boot.supportedFilesystems.zfs = mkForce false;
    networking.wireless.enable = mkForce false;
    security = {
      sudo.enable = false;
      sudo-rs.wheelNeedsPassword = false;
    };
  };
}
