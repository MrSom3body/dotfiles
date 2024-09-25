{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-fresh
    notesnook
    (obsidian.override {
      commandLineArgs = "--ozone-platform=x11";
    })
    papers
    simple-scan
  ];
}
