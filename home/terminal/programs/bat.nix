{pkgs, ...}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      prettybat
    ];
  };

  home.shellAliases = {
    cat = "bat";
    man = "batman";
  };
}
