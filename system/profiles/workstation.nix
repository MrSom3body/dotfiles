{...}: {
  imports = [
    ../global

    ../optional/programs/xdg.nix

    ../optional/hardware/graphics.nix

    ../optional/programs/hyprland.nix

    ../optional/services/flatpak.nix
    ../optional/services/gnome-services.nix
    ../optional/services/greetd.nix
    ../optional/services/pipewire.nix
    ../optional/services/printing.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = true;
  };
}
