{pkgs, ...}: {
  imports = [
    ./spotify.nix
    ./mpv.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pwvucontrol

    # audio
    amberol

    # images
    inkscape
    krita
    loupe

    # videos
    celluloid
  ];
}
