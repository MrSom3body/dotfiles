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
      satty
      wl-clipboard
      wtype
    ])
    ++ (
      with pkgs; [
        # my packages
        wl-ocr
        hyprcast
      ]
    )
    ++ [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      inputs.hyprpicker.packages.${pkgs.system}.default
    ];

  home.file.".config/hypr/scripts" = {
    source = ./scripts;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    package = null;
    portalPackage = null;
    # plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
    #   hyprbars
    # ];
  };
}
