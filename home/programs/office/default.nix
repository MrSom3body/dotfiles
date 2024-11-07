{pkgs, ...}: {
  home.packages = with pkgs; [
    (obsidian.override {commandLineArgs = "--ozone-platform=x11";})
    libreoffice-fresh
    lunatask
    notesnook
    papers
    simple-scan
  ];
}
