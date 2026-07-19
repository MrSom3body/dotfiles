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
    "gatus"
    "glance"
    # "karakeep" # TODO enable when https://github.com/NixOS/nixpkgs/issues/529285 gets resolved for karakeep
    "ntfy"
    # "open-webui" # is currently broken
    "qemu-guest"
    "radicale"
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
      imports = config.flake.lib.loadNixosAndHmModules config modules;
      services = {
        beszel.agent.environment.BESZEL_AGENT_EXTRA_FILESYSTEMS = "sdb1";
        ollama.loadModels = [
          "gemma3:12b"
          "gemma3n:e4b"
          "qwen3:8b"
        ];
      };
    };
  };
}
