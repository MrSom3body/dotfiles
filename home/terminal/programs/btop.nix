{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      cudaSupport = true;
    };

    settings = {
      vim_keys = true;
    };
  };
}
