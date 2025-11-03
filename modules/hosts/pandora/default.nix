{ config, ... }:
let
  modules = [
    "arr"
    "base"
    "server"
    "shell"

    "anubis"
    "atuin"
    "atuin-server"
    "beszel"
    "ddns-updater"
    "firefox-send"
    "glance"
    "immich"
    "jellyfin"
    "karakeep"
    "minecraft-server/kn-server"
    "miniflux"
    "ntfy"
    "searx"
    "stylix"
    # "transmission" # commented out because already imported in arr
    "ts-exit-node"
  ];
in
{
  flake.modules.nixos."hosts/pandora" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules
      "karun";
}
