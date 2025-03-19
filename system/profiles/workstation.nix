{...}: {
  imports = [
    ./common.nix

    ../../system/programs/xdg.nix
    ../../system/programs/fonts.nix

    ../../system/hardware/graphics.nix

    ../../system/programs/hyprland.nix

    ../../system/services/flatpak.nix
    ../../system/services/gnome-services.nix
    ../../system/services/greetd.nix
    ../../system/services/pipewire.nix
    ../../system/services/printing.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = true;
  };
}
