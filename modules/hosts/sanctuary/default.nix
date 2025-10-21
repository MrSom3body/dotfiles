{ config, ... }:
let
  modules = [
    "base"
    "iso"
  ];
in
{
  flake.modules.nixos."iso/sanctuary" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules
      "karun";
}
