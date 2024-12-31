{pkgs, ...}: {
  home.packages = with pkgs; [
    # Documents
    libreoffice-fresh
    papers
    simple-scan

    # Notes & Tasks
    obsidian
    todoist-electron

    # Communication
    protonmail-desktop
    slack
  ];
}
