{
  lib,
  config,
  ...
}: {
  imports = [
    ../../home/profiles/workstation.nix
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    # sh
    ''
      hyprland-dialog --title "I hope you're in a VM :)" --text "If not, then why did you just switch to my config? Haven't you read the README???"
    ''
  ];

  programs.hyprlock.settings.input-field.placeholder_text = lib.mkForce "<span foreground=\"##${config.lib.stylix.colors.base05}\">󰌾  Password is <span foreground=\"##${config.lib.stylix.colors.base0D}\"><i>password</i></span></span>";
}
