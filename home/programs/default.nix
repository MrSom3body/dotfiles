{pkgs, ...}: {
  home.packages = with pkgs; [
    # GNOME utilities
    baobab # Disk Usage Analyzer
    gnome-calculator
    gnome-clocks
    gnome-disk-utility
    gnome-weather
    kooha # Screen Recorder
    snapshot # Camera App
  ];
}
