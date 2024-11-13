{pkgs, ...}: {
  home.packages = with pkgs; [
    # Documents
    libreoffice-fresh
    papers
    simple-scan

    # Notes & Tasks
    lunatask
    obsidian
  ];
}
