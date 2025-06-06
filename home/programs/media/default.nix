{pkgs, ...}: {
  imports = [
    ./spotify.nix
    ./mpv.nix
  ];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
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
      jellyfin-media-player
      ;
  };
}
