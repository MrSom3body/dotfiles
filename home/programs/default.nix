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
    gnome-clocks
    gnome-disk-utility
    gnome-weather
    kooha # Screen Recorder
    snapshot # Camera App

    # Communication & Social Media
    element-desktop # Matrix client
    signal-desktop

    # Misc
    ente-auth
    pika-backup
    proton-pass
    protonvpn-gui
    rclone
  ];
}
