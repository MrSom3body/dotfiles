{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  # overrides needed for my config to work with the iso template
  flake.modules.nixos.iso = {
    boot.supportedFilesystems.zfs = mkForce false;
    networking.wireless.enable = mkForce false;
    security = {
      sudo.enable = false;
      sudo-rs.wheelNeedsPassword = false;
    };
  };
}
