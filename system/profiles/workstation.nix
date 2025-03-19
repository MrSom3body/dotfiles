{...}: {
  imports = [
    ./common.nix

    ../../system/hardware/graphics.nix

    ../../system/programs/hyprland.nix

    ../../system/services/flatpak.nix
    ../../system/services/gnome-services.nix
    ../../system/services/greetd.nix
    ../../system/services/pipewire.nix
    ../../system/services/printing.nix
  ];
}
