{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my.desktop.hyprland;
in
{
  imports = [
    ./scrolling.nix
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindd = lib.mkIf (cfg.layout != "scrolling") [
      "$mainMod, P, Pseudotile focused window (dwindle), pseudo"
      "$mainMod, I, Change split direction (dwindle), togglesplit"

      # Move window focus
      "$mainMod, H, Focus window to the left, movefocus, l"
      "$mainMod, J, Focus window to the bottom, movefocus, d"
      "$mainMod, K, Focus window to the top, movefocus, u"
      "$mainMod, L, Focus window to the right, movefocus, r"

      # Move window
      "$mainMod SHIFT, H, Move window left, swapwindow, l"
      "$mainMod SHIFT, J, Move window down, swapwindow, d"
      "$mainMod SHIFT, K, Move window up, swapwindow, u"
      "$mainMod SHIFT, L, Move window right, swapwindow, r"

      # Resize window
      "$mainMod CTRL, H, Increase window size to the left, resizeactive, -100 0"
      "$mainMod CTRL, J, Increase window size to the bottom, resizeactive, 0 100"
      "$mainMod CTRL, K, Increase window size to the top, resizeactive, 0 -100"
      "$mainMod CTRL, L, Increase window size to the right, resizeactive, 100 0"
    ];
  };
}
