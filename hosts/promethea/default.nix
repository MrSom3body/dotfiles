{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

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
    ../../system/optional/programs/ydotool.nix

    ../../system/optional/services/fprintd.nix
    ../../system/optional/services/gns3.nix

    ../../system/optional/virtualisation/libvirtd.nix
    ../../system/optional/virtualisation/podman.nix
  ]
  ++ [
    inputs.nixos-hardware.nixosModules.asus-zenbook-um6702
  ];

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
          ExecStart = ''${config.hardware.nvidia.package.out}/bin/nvidia-sleep.sh "suspend"'';
        };
        before = [ "systemd-${state}.service" ];
        requiredBy = [ "systemd-${state}.service" ];
      };

    nvidia-resume = {
      after = [ "systemd-suspend-then-hibernate.service" ];
      requiredBy = [ "systemd-suspend-then-hibernate.service" ];
    };
  };

  my = {
    boot.lanzaboote.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ]; # TODO remove https://github.com/NixOS/nixpkgs/issues/437865

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
