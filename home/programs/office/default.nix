{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-fresh
    notesnook
    obsidian
    papers
  ];
}
