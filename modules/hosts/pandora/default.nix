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
    "ddns-updater"
    "firefox-send"
    "immich"
    "miniflux"
    "stylix"
    "syncthing-server"
    # "transmission" # commented out because already imported in arr
    "tailscale-exit-node"
    "topology"
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
