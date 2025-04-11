{
  inputs,
  config,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../common/profiles/laptop.nix

      ../common/optional/core/lanzaboote.nix

      ../common/optional/hardware/opentabletdriver.nix
      ../common/optional/hardware/logitech.nix

      ../common/optional/network/kdeconnect.nix
      ../common/optional/network/spotify.nix

      ../common/optional/programs/adb.nix
      ../common/optional/programs/gamemode.nix
      ../common/optional/programs/steam.nix
      ../common/optional/programs/vmware.nix
      ../common/optional/programs/wireshark.nix

      ../common/optional/services/fprintd.nix
      ../common/optional/services/gns3.nix
      ../common/optional/services/ollama.nix

      ../common/optional/virtualisation/libvirtd.nix
      ../common/optional/virtualisation/podman.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc-laptop
      common-cpu-amd-pstate
      common-gpu-nvidia
      asus-battery
    ]);

  services.tailscale.extraSetFlags = ["--accept-routes"];

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
