{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./settings.nix
    ./binds.nix
    ./rules.nix
    ./pyprland.nix
  ];

  home.packages =
    (with pkgs; [
      brightnessctl
      nautilus
      networkmanagerapplet
      nwg-displays
      wl-clipboard
      wl-screenrec
      satty
    ])
    ++ (with inputs.hyprland-contrib.packages.${pkgs.system}; [
      grimblast
    ])
    ++ [
      inputs.hyprpicker.packages.${pkgs.system}.default
    ];

  home.file.".config/hypr/scripts" = {
    source = ./scripts;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    # plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
    #   hyprbars
    # ];
  };
}
