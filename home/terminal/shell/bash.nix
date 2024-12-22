{pkgs, ...}: {
  programs.bash = {
    enable = true;
    # initExtra = "macchina";
    shellAliases = {
      ip = "ip -c";
      l = "ls";
      icat = "${pkgs.libsixel}/bin/img2sixel";
    };
  };
}
