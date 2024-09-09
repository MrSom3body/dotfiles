{dotfiles, ...}: {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep-since 4d --keep 3";
    };
    flake = dotfiles.path;
  };
}
