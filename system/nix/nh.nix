{settings, ...}: {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 1w --keep 3";
    };
    flake = settings.path;
  };
}
