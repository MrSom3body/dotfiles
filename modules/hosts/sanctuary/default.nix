{ config, ... }:
let
  modules = [
    "base"
    "iso"
  ];
in
{
  flake.modules.nixos."hosts/sanctuary-iso" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules
      "karun";
}
