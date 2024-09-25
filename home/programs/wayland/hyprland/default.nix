{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./settings.nix
    ./keybindings.nix
    ./rules.nix
    ./pyprland.nix
  ];

  home.packages =
    (with pkgs; [
      brightnessctl
      hyprshot
      nautilus
      networkmanagerapplet
      nwg-displays
      wl-clipboard
      wl-screenrec
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
    systemd = {
      enable = true;
      variables = ["--all"];
    };

    plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
      hyprbars
    ];
  };
}
