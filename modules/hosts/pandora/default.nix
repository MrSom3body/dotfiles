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
    "minecraft-server/kn-server"
    "miniflux"
    "ntfy"
    "searx"
    "stylix"
    "syncthing-server"
    # "transmission" # commented out because already imported in arr
    "tailscale-exit-node"
  ];
in
{
  flake = {
    nixosConfigurations.pandora = config.flake.lib.mkSystems.linux "pandora";
    modules.nixos."hosts/pandora" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
    };
  };
}
