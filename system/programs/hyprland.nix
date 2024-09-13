_: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # tell Electron/Chromium to run on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
