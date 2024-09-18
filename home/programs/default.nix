{pkgs, ...}: {
  imports = [
    ./browsers/firefox.nix
    ./media
    ./office

    ./solaar.nix
    ./vesktop.nix
  ];

  home.packages = with pkgs; [
    # GNOME
    baobab # Disk Usage Analyzer
    gnome-calculator
    gnome-disk-utility
    gnome-weather
    kooha # Screen Recorder
    snapshot # Camera App

    # Messaging and socials
    signal-desktop
    tuba # Mastodon Client

    # Tools
    pika-backup

    # JetBrains
    jetbrains.idea-ultimate
    jetbrains.phpstorm
    jetbrains.datagrip

    # Proton
    proton-pass
    protonvpn-gui
  ];
}
