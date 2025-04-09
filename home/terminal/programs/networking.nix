{pkgs, ...}: {
  home.packages = with pkgs; [
    dig
    iputils
    nmap
  ];
}
