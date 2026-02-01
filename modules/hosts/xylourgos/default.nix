{ config, ... }:
let
  hostName = "xylourgos";
  modules = [
    "oracle-keep-alive" # DO NOT REMOVE

    "base"
    "server"
    "shell"

    "atuin"
    "beszel"
    "glance"
    "minecraft-server/kn-server"
    "ntfy"
    "qemu-guest"
    "searx"
    "stylix"
    "syncthing-server"
    "tailscale-exit-node"
  ];
in
{
  flake = {
    nixosConfigurations.${hostName} = config.flake.lib.mkSystems.linux-arm hostName;
    modules.nixos."hosts/${hostName}" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
    };
  };
}
