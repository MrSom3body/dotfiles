{ lib, ... }:
{
  services.fwupd.enable = lib.mkDefault true;
}
