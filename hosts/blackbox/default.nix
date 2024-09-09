{...}: {
  imports = [
    ./hardware-configuration.nix

    ../common/laptop.nix

    ../../system/hardware/asus.nix
    ../../system/hardware/opentabletdriver.nix
    ../../system/hardware/logitech.nix
    ../../system/hardware/nvidia.nix

    ../../system/network/spotify.nix

    ../../system/programs/gamemode.nix
    ../../system/programs/hyprland.nix
    ../../system/programs/steam.nix
    ../../system/programs/vmware.nix
    ../../system/programs/zerotier.nix

    ../../system/services/fprintd.nix
    ../../system/services/gnome-services.nix
    ../../system/services/gns3.nix
    ../../system/services/location.nix
    ../../system/services/printing.nix

    ../../system/virtualisation/libvirtd.nix
    ../../system/virtualisation/podman.nix

    ../../system/style/stylix.nix
  ];

  boot = {
    kernelModules = ["i2c-dev"];
    kernelParams = [
      "amd_pstate=active"
    ];
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;

  # services.pipewire = { package = pkgs.pipewire.overrideAttrs (
  #     {patches ? [], ...}: {
  #       patches = [ ./patches/ASUS_ZenBook_UM6702RC.patch ] ++ patches;
  #     }
  #   );
  # };
}
