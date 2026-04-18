{ config, inputs, ... }:
let
  flakeConfig = config;
  modules = [
    "borgmatic"
    "desktop"
    "dev"
    "gaming"
    "hyprland"
    "laptop"
    "media"
    "messaging"
    "office"
    "school"
    "shell"

    "adb"
    "atuin"
    "bluetooth"
    "claude-code"
    # "design"
    "emulation"
    "fingerprint"
    "flatpak"
    "gemini-cli"
    "gns3"
    "lanzaboote"
    "libvirtd"
    "logitech"
    "opentabletdriver"
    "podman"
    "printing"
    "proton"
    "rclone"
    "terraform"
    "topology"
    "vmware"
    "wireshark"
    "ydotool"
  ];
in
{
  flake = {
    nixosConfigurations.promethea = flakeConfig.flake.lib.mkSystems.linux "promethea";
    modules = {
      nixos."hosts/promethea" =
        { config, ... }:
        {
          imports = (flakeConfig.flake.lib.loadNixosAndHmModuleForUser flakeConfig modules) ++ [
            inputs.nixos-hardware.nixosModules.asus-zenbook-um6702
          ];

          hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

          hardware.asus.battery.chargeUpto = 80;
          security.tpm2.enable = true;

          services.tailscale.extraSetFlags = [ "--accept-routes" ];
        };

      homeManager."hosts/promethea" =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.calibre
            pkgs.logseq
            pkgs.todoist-electron
            pkgs.planify
          ];
          wayland.windowManager.hyprland = {
            layout = "scrolling";
            settings = {
              monitorv2 = [
                {
                  output = "eDP-1";
                  mode = "1920x1080@60.08Hz";
                  position = "auto";
                  scale = "1";
                }
                {
                  output = "desc:AOC 24B3HMA2 1OVQ5HA003115";
                  mode = "1920x1080@100.00Hz";
                  position = "auto";
                  scale = "1";
                }
              ];

              workspace = [
                "4, monitor:HDMI-A-1"
                "5, monitor:HDMI-A-1"
              ];

              permission = [
                ### Keyboards ###
                "video-bus, keyboard, allow"
                "asus-wmi-hotkeys, keyboard, allow"
                "at-translated-set-2-keyboard, keyboard, allow"

                # Logitech
                "mx-mchncl-m-keyboard, keyboard, allow"
                "logitech-usb-receiver, keyboard, allow"
                "logitech-usb-receiver-consumer-control, keyboard, allow"
                "logitech-usb-receiver-system-control, keyboard, allow"

                # Mechanical Keyboard
                "sonix-usb-device-system-control, keyboard, allow"
                "sonix-usb-device, keyboard, allow"
                "sonix-usb-device-keyboard, keyboard, allow"
                "sonix-usb-device-consumer-control, keyboard, allow"

                # Presentation control
                "qiya-wireless-device, keyboard, allow"
                "qiya-wireless-device-system-control, keyboard, allow"
                "qiya-wireless-device-consumer-control, keyboard, allow"

                # Deny everything else
                ".*, keyboard, deny"
              ];
            };
          };
        };
    };
  };
}
