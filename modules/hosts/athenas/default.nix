{ config, ... }:
let
  modules = [
    "base"
    "desktop"
    "dev"
    "iso"
    "laptop"
    "office"
    "shell"

    "bluetooth"
    "opentabletdriver"
    "podman"
    "printing"
  ];
in
{
  flake.modules.nixos."hosts/athenas-iso" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules
      "karun";
}
