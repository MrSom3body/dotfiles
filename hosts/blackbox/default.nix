{
  config,
  inputs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix

      ../common/laptop.nix

      ../../system/hardware/asus.nix
      ../../system/hardware/opentabletdriver.nix
      ../../system/hardware/logitech.nix

      ../../system/network/spotify.nix

      ../../system/programs/gamemode.nix
      ../../system/programs/hyprland.nix
      ../../system/programs/steam.nix
      ../../system/programs/vmware.nix
      ../../system/programs/wireshark.nix

      ../../system/services/fprintd.nix
      ../../system/services/gnome-services.nix
      ../../system/services/gns3.nix
      ../../system/services/location.nix
      ../../system/services/printing.nix
      ../../system/services/zerotier.nix
      ../../system/services/ollama.nix
      ../../system/services/ollama.nix

      ../../system/virtualisation/libvirtd.nix
      ../../system/virtualisation/podman.nix

      ../../system/style/stylix.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc-laptop
      common-pc-laptop-ssd
      asus-battery

      common-cpu-amd
      common-cpu-amd-pstate

      common-gpu-amd
      common-gpu-nvidia
    ]);

  hardware = {
    asus.battery.chargeUpto = 75;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;

      powerManagement.finegrained = true;

      dynamicBoost.enable = true;
      prime = {
        nvidiaBusId = "PCI:101:00:0";
        amdgpuBusId = "PCI:01:00:0";
      };
    };
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
