{pkgs, ...}: {
  imports = [
    ./browsers/firefox.nix
    ./media
    ./office

    ./solaar.nix
    ./vesktop.nix
  ];

  home.packages = with pkgs; [
    pika-backup
    signal-desktop

    # GNOME
    baobab # Disk Usage Analyzer
    gnome-calculator
    gnome-disk-utility
    gnome-weather
    kooha # Screen Recorder
    snapshot # Camera App

    # JetBrains
    jetbrains.idea-ultimate
    jetbrains.phpstorm

    # Proton
    proton-pass
    protonvpn-gui

    # Misc
    papirus-icon-theme
  ];
}