{
  imports = [
    ./server.nix

    # terminals
    ../terminal/emulators/foot.nix

    # system services
    ../services/system/polkit.nix
    ../services/system/udiskie.nix

    # wayland services
    ../services/cliphist.nix
    ../services/fnott
    ../services/gammastep.nix
    ../services/hypridle.nix
    ../services/hyprpaper.nix
    ../services/swayosd.nix
  ];

  my = {
    desktop.enable = true;
    browsers.zen-browser = {
      enable = true;
      default = true;
    };
    media.enable = true;
    office.enable = true;
    utils.enable = true;
  };
}
