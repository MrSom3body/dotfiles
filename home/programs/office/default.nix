{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    # Documents
    libreoffice-fresh
    simple-scan

    # Notes & Tasks
    obsidian
    todoist-electron

    # Communication
    protonmail-desktop
    slack
  ];
}
