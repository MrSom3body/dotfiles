{ config, ... }:
let
  modules = [
    "arr"
    "server"
    "shell"

    "atuin"
    "atuin-server"
    "borgmatic"
    "cloudflared"
    "immich"
    "minecraft-server/home-server"
    "miniflux"
    "nextdns-link"
    "paperless"
    "podman"
    "smartd"
    "stylix"
    "syncthing-server"
    # "transmission" # commented out because already imported in arr
    "tailscale-exit-node"
    "topology"
    "wallos"
  ];
in
{
  flake = {
    nixosConfigurations.pandora = config.flake.lib.mkSystems.linux "pandora";
    modules.nixos."hosts/pandora" = {
      imports = config.flake.lib.loadNixosAndHmModules config modules;
      services.beszel.agent.environment.BESZEL_AGENT_EXTRA_FILESYSTEMS = "sdb1";
    };
  };
}
