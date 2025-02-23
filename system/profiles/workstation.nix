{inputs, ...}: {
  imports = [
    ../../system/core

    ../../system/hardware/fwupd.nix
    ../../system/hardware/graphics.nix

    ../../system/network
    ../../system/network/avahi.nix

    ../../system/programs
    ../../system/programs/hyprland.nix
    ../../system/programs/command-not-found.nix

    ../../system/services
    ../../system/services/flatpak.nix
    ../../system/services/gnome-services.nix
    ../../system/services/greetd.nix
    ../../system/services/pipewire.nix
    ../../system/services/printing.nix

    ../../system/virtualisation/vm.nix

    ../../system/style/stylix.nix

    inputs.stylix.nixosModules.stylix
  ];

  hardware.enableAllFirmware = true;
}
