{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      dig
      iputils
      nmap
      ;
  };
}
