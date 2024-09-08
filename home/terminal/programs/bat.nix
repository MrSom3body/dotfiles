{pkgs, ...}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batman
      batpipe
      batwatch
      # batdiff
      prettybat
    ];
  };

  home.shellAliases = {
    cat = "bat";
    # rg = "batgrep";
    man = "batman";
    less = "batpipe";
    # diff = "batdiff";
  };
}
