{ config, ... }:
let
  modules = [ "base" ];
in
{
  flake.modules.nixos."iso/sanctuary" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules
      "karun";
}
