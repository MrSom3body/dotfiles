{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      cudaSupport = true;
    };

    settings = {
      update_ms = 700;
      vim_keys = true;
    };
  };
}
