{pkgs, ...}: {
  home.packages = with pkgs; [macchina];
  home.file.".config/macchina".source = ./configs;
}
