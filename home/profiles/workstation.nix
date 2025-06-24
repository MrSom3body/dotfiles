{
  imports = [
    ./server.nix

    # terminals
    ../terminal/emulators/foot.nix

    # programs
    ../programs
    ../programs/office

    # wayland programs
    ../programs/wayland/fuzzel
    ../programs/wayland/hyprland
    ../programs/wayland/hyprlock.nix
    ../programs/wayland/waybar

    # system services
    ../services/system/polkit.nix
    ../services/system/udiskie.nix

    # wayland services
    ../services/wayland/cliphist.nix
    ../services/wayland/fnott
    ../services/wayland/gammastep.nix
    ../services/wayland/hypridle.nix
    ../services/wayland/hyprpaper.nix
    ../services/wayland/swayosd.nix
  ];

  my = {
    media.enable = true;

    browsers.zen-browser = {
      enable = true;
      default = true;
    };
  };
}
