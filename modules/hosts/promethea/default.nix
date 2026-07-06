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
    "shell"

    "adb"
    "antigravity-cli"
    "atuin"
    "bluetooth"
    "clamav"
    "claude-code"
    # "design"
    "distrobox"
    "emulation"
    "fingerprint"
    "flatpak"
    "jetbrains"
    "lanzaboote"
    "libvirtd"
    "logitech"
    "opentabletdriver"
    "podman"
    "printing"
    "proton"
    "topology"
  ];
in
{
  flake = {
    nixosConfigurations.promethea = flakeConfig.flake.lib.mkSystems.linux "promethea";
    modules = {
      nixos."hosts/promethea" = {
        imports = (flakeConfig.flake.lib.loadNixosAndHmModules flakeConfig modules) ++ [
          inputs.nixos-hardware.nixosModules.asus-zenbook-um6702
        ];

        hardware.nvidia.branch = "latest";

        hardware.asus.battery.chargeUpto = 80;
        security.tpm2.enable = true;

        services.tailscale.extraSetFlags = [ "--accept-routes" ];
      };

      homeManager."hosts/promethea" = { pkgs, ... }: {
        home.packages = [
          pkgs.calibre
          # pkgs.logseq # TODO broken due to https://github.com/NixOS/nixpkgs/issues/521305
          pkgs.planify
        ];
        wayland.windowManager.hyprland = {
          layout = "scrolling";
          settings = {
            monitor = [
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

            workspace_rule = [
              {
                workspace = "4";
                monitor = "HDMI-A-1";
              }
              {
                workspace = "5";
                monitor = "HDMI-A-1";
              }
            ];

            permission = [
              ### Keyboards ###
              {
                binary = "video-bus";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "asus-wmi-hotkeys";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "at-translated-set-2-keyboard";
                type = "keyboard";
                mode = "allow";
              }

              # Logitech
              {
                binary = "mx-mchncl-m-keyboard";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "logitech-usb-receiver";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "logitech-usb-receiver-consumer-control";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "logitech-usb-receiver-system-control";
                type = "keyboard";
                mode = "allow";
              }

              # Mechanical Keyboard
              {
                binary = "sonix-usb-device-system-control";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "sonix-usb-device";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "sonix-usb-device-keyboard";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "sonix-usb-device-consumer-control";
                type = "keyboard";
                mode = "allow";
              }

              # Presentation control
              {
                binary = "qiya-wireless-device";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "qiya-wireless-device-system-control";
                type = "keyboard";
                mode = "allow";
              }
              {
                binary = "qiya-wireless-device-consumer-control";
                type = "keyboard";
                mode = "allow";
              }

              # Deny everything else
              {
                binary = ".*";
                type = "keyboard";
                mode = "deny";
              }
            ];
          };
        };
      };
    };
  };
}
