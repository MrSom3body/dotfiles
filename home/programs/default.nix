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

    # Development Tools
    (pkgs.jetbrains.plugins.addPlugins jetbrains.datagrip ["github-copilot-intellij" "ideavim"])
    (pkgs.jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot-intellij" "ideavim"])
    (pkgs.jetbrains.plugins.addPlugins jetbrains.phpstorm ["github-copilot-intellij" "ideavim"])
    temurin-bin

    # Misc
    easyeffects
    ente-auth
    pika-backup
    proton-pass
    protonvpn-gui
  ];
}
