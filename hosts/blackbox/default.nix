{
  inputs,
  config,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../../system/core/lanzaboote.nix

      ../common/laptop.nix

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

      ../../system/virtualisation/libvirtd.nix
      ../../system/virtualisation/podman.nix

      ../../system/style/stylix.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      asus-battery
    ]);

  boot = {
    kernelParams = [
      "amd_pstate=active"
    ];
    kernelModules = ["nvidia_uvm"];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    amdgpu.initrd.enable = true;

    asus.battery.chargeUpto = 75;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      dynamicBoost.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:01:00:0";
        nvidiaBusId = "PCI:101:00:0";
      };
    };
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
