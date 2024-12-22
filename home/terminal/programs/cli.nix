{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    libnotify

    # utils
    devenv
    glow
    speedtest-cli
    trash-cli
    wget
  ];
}
