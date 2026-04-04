{ config, ... }:
let
  hostName = "xylourgos";
  modules = [
    "oracle-keep-alive" # DO NOT REMOVE

    "server"
    "shell"

    "atuin"
    "beszel"
    "borgmatic"
    "ddns-updater"
    "firefox-send"
    "glance"
    "ntfy"
    # "open-webui" # is currently broken
    "qemu-guest"
    "searx"
    "stylix"
    "syncthing-server"
    "tailscale-exit-node"
    "topology"
    "wakapi"
  ];
in
{
  flake = {
    nixosConfigurations.${hostName} = config.flake.lib.mkSystems.linux-arm hostName;
    modules.nixos."hosts/${hostName}" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
      services.ollama.loadModels = [
        "gemma3:12b"
        "gemma3n:e4b"
        "qwen3:8b"
      ];
    };
  };
}
