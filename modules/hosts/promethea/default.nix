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
  flake.modules.nixos."hosts/promethea" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules
      "karun";
}
