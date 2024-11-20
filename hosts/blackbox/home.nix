{...}: {
  imports = [
    # home manager stuff
    ../../home

    # editors
    ../../home/editors/helix
    ../../home/editors/nvim

    # terminals
    ../../home/terminal/emulators/alacritty.nix
    ../../home/terminal/emulators/foot.nix
    ../../home/terminal/emulators/kitty.nix

    # programs
    ../../home/programs
    ../../home/programs/games
    ../../home/programs/school
    ../../home/programs/wayland

    # media services
    ../../home/services/media/playerctl.nix

    # system services
    ../../home/services/system/gpg-agent.nix
    ../../home/services/system/kdeconnect.nix
    ../../home/services/system/polkit.nix
    ../../home/services/system/syncthing.nix
    ../../home/services/system/udiskie.nix

    # wayland services
    ../../home/services/wayland/cliphist.nix
    ../../home/services/wayland/gammastep.nix
    ../../home/services/wayland/hypridle.nix
    ../../home/services/wayland/hyprpaper.nix
    ../../home/services/wayland/swaync
    ../../home/services/wayland/swayosd.nix

    # styles
    ../../home/style/stylix.nix
    ../../home/style/gtk.nix
  ];
}
