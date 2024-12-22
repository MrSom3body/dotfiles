{pkgs, ...}: {
  home.packages = with pkgs; [
    trash-cli
  ];
}
