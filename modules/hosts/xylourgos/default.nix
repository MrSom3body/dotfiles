{ config, ... }:
let
  hostName = "xylourgos";
  modules = [
    "base"
    "server"

    "atuin"
    "atuin-server"
    "beszel"
    "qemu-guest"
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
