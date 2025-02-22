{
  lib,
  config,
  ...
}: {
  imports = [
    # home manager stuff
    ../../home

    # editors
    ../../home/editors/helix

    # terminals
    ../../home/terminal/emulators/foot.nix

    # programs
    ../../home/programs
    ../../home/programs/wayland

    # media services
    ../../home/services/media/playerctl.nix

    # system services
    ../../home/services/system/polkit.nix
    ../../home/services/system/udiskie.nix

    # wayland services
    ../../home/services/wayland/cliphist.nix
    ../../home/services/wayland/fnott
    ../../home/services/wayland/gammastep.nix
    ../../home/services/wayland/hypridle.nix
    ../../home/services/wayland/hyprpaper.nix
    ../../home/services/wayland/swayosd.nix

    # styles
    ../../home/style/stylix.nix
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    # sh
    ''
      hyprland-dialog --title "I hope you're in a VM :)" --text "If not, then why did you just switch to my config? Haven't you read the README???"
    ''
  ];

  programs.hyprlock.settings.input-field.placeholder_text = lib.mkForce "<span foreground=\"##${config.lib.stylix.colors.base05}\">󰌾  Password is <span foreground=\"##${config.lib.stylix.colors.base0D}\"><i>password</i></span></span>";
}
