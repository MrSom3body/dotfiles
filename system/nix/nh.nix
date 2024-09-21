{dotfiles, ...}: {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
    flake = dotfiles.path;
  };
}
