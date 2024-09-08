{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./settings.nix
    ./keybindings.nix
    ./rules.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    grimblast
    hyprpicker
    hyprshot
    nautilus
    networkmanagerapplet
    nwg-displays
    wl-clipboard
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
