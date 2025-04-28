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

  home.packages = let
    inherit (inputs.hyprpicker.packages.${pkgs.system}) hyprpicker;
  in
    (with pkgs; [
      brightnessctl
      nautilus
      networkmanagerapplet
      nwg-displays
      satty
      wl-clipboard
      wtype
    ])
    ++ (with pkgs; [
      # my packages
      wl-ocr
      hyprcast
    ])
    ++ [
      hyprpicker
      (inputs.hyprland-contrib.packages.${pkgs.system}.grimblast.override {inherit hyprpicker;})
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
