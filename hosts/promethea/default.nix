{
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports =
    [
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
      ../../system/optional/services/ollama.nix

      ../../system/optional/virtualisation/libvirtd.nix
      ../../system/optional/virtualisation/podman.nix
    ]
    ++ [
      inputs.nixos-hardware.nixosModules.asus-zenbook-um6702
    ];

  my = {
    boot.lanzaboote.enable = true;
  };

  services = {
    tailscale.extraSetFlags = ["--accept-routes"];
    ollama.acceleration = "cuda";
  };

  hardware = {
    asus.battery.chargeUpto = 80;
    nvidia.primeBatterySaverSpecialisation = true;
  };

  specialisation = {
    # extend the specialisation provided by primeBatterySaverSpecialisation
    battery-saver.configuration = {
      environment.etc."specialisation".text = "battery-saver"; # for nh

      # disable ollama
      services.ollama.enable = mkForce false;
    };
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
