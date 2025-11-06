{ config, ... }:
let
  modules = [
    "base"
    "desktop"
    "dev"
    "gaming"
    "laptop"
    "media"
    "messaging"
    "office"
    "school"
    "shell"

    "adb"
    "atuin"
    "bluetooth"
    # "design"
    "fingerprint"
    "flatpak"
    "gns3"
    "helix-gpt"
    "lanzaboote"
    "libvirtd"
    "logitech"
    "ntfy-client"
    "opentabletdriver"
    "podman"
    "printing"
    "proton"
    "rclone"
    "terraform"
    "vmware"
    "wireshark"
    "ydotool"
  ];
in
{
  flake = {
    nixosConfigurations.promethea = config.flake.lib.mkSystems.linux "promethea";
    modules.nixos."hosts/promethea" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
    };
  };
}
