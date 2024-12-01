{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.fira-code
  ];
}
