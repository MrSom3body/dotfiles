{pkgs, ...}: {
  imports = [
    ./browsers/firefox.nix
    ./media
    ./office

    ./solaar.nix
    ./vesktop.nix
  ];

  home.packages = with pkgs; [
    # GNOME utilities
    baobab # Disk Usage Analyzer
    gnome-calculator
    gnome-disk-utility
    gnome-weather
    kooha # Screen Recorder
    snapshot # Camera App

    # Communication & Social Media
    element-desktop # Matrix client
    signal-desktop
    tuba # Mastodon Client

    # Development Tools
    jetbrains.datagrip
    jetbrains.idea-ultimate
    jetbrains.phpstorm

    # Misc
    pika-backup
    proton-pass
    protonvpn-gui
  ];
}
