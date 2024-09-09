{inputs, ...}: {
  imports = [
    ../../system/core

    ../../system/hardware/bluetooth.nix
    ../../system/hardware/fwupd.nix
    ../../system/hardware/graphics.nix

    ../../system/network
    ../../system/network/avahi.nix

    ../../system/programs

    ../../system/services
    ../../system/services/greetd.nix
    ../../system/services/pipewire.nix
    ../../system/services/power.nix
    ../../system/services/timesyncd.nix

    inputs.stylix.nixosModules.stylix
  ];
}
