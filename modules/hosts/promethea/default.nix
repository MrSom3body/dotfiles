{ config, inputs, ... }:
let
  flakeConfig = config;
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
    nixosConfigurations.promethea = flakeConfig.flake.lib.mkSystems.linux "promethea";
    modules = {
      nixos."hosts/promethea" =
        { config, pkgs, ... }:
        {
          imports = (flakeConfig.flake.lib.loadNixosAndHmModuleForUser flakeConfig modules) ++ [
            inputs.nixos-hardware.nixosModules.asus-zenbook-um6702
          ];

          hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

          # TODO remove when https://github.com/NixOS/nixpkgs/pull/440422 gets merged
          systemd.services = {
            nvidia-suspend-then-hibernate =
              let
                state = "suspend-then-hibernate";
              in
              {
                description = "NVIDIA system ${state} actions";
                path = [ pkgs.kbd ];
                serviceConfig = {
                  Type = "oneshot";
                  ExecStart = [
                    ''${config.hardware.nvidia.package.out}/bin/nvidia-sleep.sh "is-suspend-then-hibernate-supported"''
                    ''${config.hardware.nvidia.package.out}/bin/nvidia-sleep.sh "suspend"''
                  ];
                };
                before = [ "systemd-${state}.service" ];
                requiredBy = [ "systemd-${state}.service" ];
              };

            nvidia-resume = {
              after = [ "systemd-suspend-then-hibernate.service" ];
              requiredBy = [ "systemd-suspend-then-hibernate.service" ];
            };
          };

          boot.kernelParams = [ "amdgpu.dcdebugmask=0x40000" ];
          hardware.asus.battery.chargeUpto = 80;
          security.tpm2.enable = true;

          specialisation.enable-ollama.configuration = {
            environment.etc."specialisation".text = "enable-ollama"; # for nh
            system.nixos.tags = [ "enable-ollama" ]; # to display it in the boot loader
            imports = [ flakeConfig.flake.modules.nixos.ollama ];
            services.ollama.package = pkgs.ollama-cuda;
          };

          services.tailscale.extraSetFlags = [ "--accept-routes" ];
        };

      homeManager."hosts/promethea" =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.calibre
            pkgs.logseq
          ];
          wayland.windowManager.hyprland.settings = {
            monitorv2 = [
              {
                output = "eDP-1";
                mode = "1920x1080@60.08Hz";
                position = "auto";
                scale = "1";
              }
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

              # Deny everything else
              ".*, keyboard, deny"
            ];
          };
        };
    };
  };
}
