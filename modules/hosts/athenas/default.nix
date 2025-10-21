{ config, ... }:
let
  modules = [
    "base"
    "desktop"
    "dev"
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
  flake.modules.nixos."iso/athenas" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules
      "karun";
}
