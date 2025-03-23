{
  inputs,
  config,
  ...
}: {
  imports =
    [
      ../../system/profiles/laptop.nix
      ./hardware-configuration.nix

      ../../system/core/lanzaboote.nix

      ../../system/hardware/opentabletdriver.nix
      ../../system/hardware/logitech.nix

      ../../system/network/kdeconnect.nix
      ../../system/network/spotify.nix

      ../../system/programs/gamemode.nix
      ../../system/programs/steam.nix
      ../../system/programs/vmware.nix
      ../../system/programs/wireshark.nix

      ../../system/services/fprintd.nix
      ../../system/services/gns3.nix
      ../../system/services/nextdns.nix
      ../../system/services/ollama.nix
      ../../system/services/tailscale.nix

      ../../system/virtualisation/libvirtd.nix
      ../../system/virtualisation/podman.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc-laptop
      common-cpu-amd-pstate
      common-gpu-nvidia
      asus-battery
    ]);

  services.tailscale = {
    useRoutingFeatures = "client";
    extraUpFlags = ["--accept-routes"];
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
