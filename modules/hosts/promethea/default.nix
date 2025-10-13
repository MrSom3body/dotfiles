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
    "design"
    "fingerprint"
    "flatpak"
    "gns3"
    "lanzaboote"
    "libvirtd"
    "logitech"
    "ntfy-client"
    "opentabletdriver"
    "podman"
    "printing"
    "rclone"
    "vmware"
    "wireshark"
    "ydotool"
  ];
in
{
  flake.modules.nixos."hosts/promethea" =
    config.flake.lib.loadNixosAndHmModuleForUser config modules "karun"
  # // {
  #   imports = [ inputs.nixos-hardware.nixosModules.asus-zenbook-um6702 ];

  #   hardware = {
  #     asus.battery.chargeUpto = 80;
  #   };

  #   specialisation.enable-ollama.configuration = {
  #     environment.etc."specialisation".text = "enable-ollama"; # for nh
  #     system.nixos.tags = [ "enable-ollama" ]; # to display it in the boot loader
  #     imports = [ config.flake.modules.nixos.ollama ];
  #   };

  #   security.tpm2.enable = true;
  #   powerManagement.enable = true;
  # };
  ;
}
