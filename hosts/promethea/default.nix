{
  inputs,
  config,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../../system/profiles/laptop.nix

      ../../system/optional/core/lanzaboote.nix

      ../../system/optional/hardware/opentabletdriver.nix
      ../../system/optional/hardware/logitech.nix

      ../../system/optional/network/kdeconnect.nix
      ../../system/optional/network/spotify.nix
      ../../system/optional/network/tuxshare.nix

      ../../system/optional/programs/adb.nix
      ../../system/optional/programs/gamemode.nix
      ../../system/optional/programs/steam.nix
      ../../system/optional/programs/vmware.nix
      ../../system/optional/programs/wireshark.nix

      ../../system/optional/services/fprintd.nix
      ../../system/optional/services/gns3.nix
      ../../system/optional/services/ollama.nix

      ../../system/optional/virtualisation/containerlab.nix
      ../../system/optional/virtualisation/libvirtd.nix
      ../../system/optional/virtualisation/podman.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc-laptop
      common-cpu-amd-pstate
      common-gpu-nvidia
      asus-battery
    ]);

  services = {
    tailscale.extraSetFlags = ["--accept-routes"];
    ollama.acceleration = "cuda";
  };

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
        amdgpuBusId = "PCI:01:00:0";
        nvidiaBusId = "PCI:101:00:0";
      };
    };
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
