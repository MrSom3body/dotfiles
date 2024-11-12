{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-fresh
    lunatask
    notesnook
    obsidian
    papers
    simple-scan
  ];
}
