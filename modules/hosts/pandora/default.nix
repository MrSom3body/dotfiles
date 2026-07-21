{ config, ... }:
let
  modules = [
    "arr"
    "server"
    "shell"

    "atuin"
    "atuin-server"
    "borgmatic"
    "immich"
    "minecraft-server/kn-server"
    "miniflux"
    "smartd"
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
      imports = config.flake.lib.loadNixosAndHmModules config modules;
      services.beszel.agent.environment.BESZEL_AGENT_EXTRA_FILESYSTEMS = "sdb";
    };
  };
}
