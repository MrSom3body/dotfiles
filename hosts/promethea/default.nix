{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/profiles/laptop.nix

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

    ../../system/optional/virtualisation/libvirtd.nix
    ../../system/optional/virtualisation/podman.nix
  ]
  ++ [
    inputs.nixos-hardware.nixosModules.asus-zenbook-um6702
  ];

  my = {
    boot.lanzaboote.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ]; # for jellyfin see https://github.com/NixOS/nixpkgs/issues/437865

  boot.kernelParams = [ "amdgpu.dcdebugmask=0x40000" ];

  services = {
    tailscale.extraSetFlags = [ "--accept-routes" ];
    ollama.acceleration = "cuda";
  };

  hardware = {
    asus.battery.chargeUpto = 80;
  };

  specialisation.enable-ollama.configuration = {
    environment.etc."specialisation".text = "enable-ollama"; # for nh
    system.nixos.tags = [ "enable-ollama" ]; # to display it in the boot loader
    imports = [
      ../../system/optional/services/ollama.nix
    ];
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
