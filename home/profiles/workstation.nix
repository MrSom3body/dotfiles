{
  imports = [
    ./server.nix

    # terminals
    ../../home/terminal/emulators/foot.nix

    # programs
    ../../home/programs
    ../../home/programs/browsers/firefox.nix
    ../../home/programs/media
    ../../home/programs/office

    # wayland programs
    ../../home/programs/wayland/fuzzel
    ../../home/programs/wayland/hyprland
    ../../home/programs/wayland/hyprlock.nix
    ../../home/programs/wayland/waybar

    # system services
    ../../home/services/system/polkit.nix
    ../../home/services/system/udiskie.nix

    # media services
    ../../home/services/media/playerctl.nix

    # wayland services
    ../../home/services/wayland/cliphist.nix
    ../../home/services/wayland/fnott
    ../../home/services/wayland/gammastep.nix
    ../../home/services/wayland/hypridle.nix
    ../../home/services/wayland/hyprpaper.nix
    ../../home/services/wayland/swayosd.nix
  ];
}
