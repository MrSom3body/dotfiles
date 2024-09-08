{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    libnotify

    # utils
    speedtest-cli
    tldr
    wget
  ];
}
