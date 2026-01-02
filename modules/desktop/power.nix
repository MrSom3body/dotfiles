{ lib, ... }:
{
  flake.modules.nixos.desktop = {
    services = {
      tuned.enable = true;
      tlp.enable = lib.mkForce false;

      upower.enable = true;
    };
  };
}
