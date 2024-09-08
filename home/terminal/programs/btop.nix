{...}: {
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 700;
      vim_keys = true;
    };
  };
}
