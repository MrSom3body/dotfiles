{pkgs, ...}: {
  imports = [
    ./spotify.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pwvucontrol

    # audio
    amberol

    # images
    loupe
    krita

    # videos
    totem
  ];
}
