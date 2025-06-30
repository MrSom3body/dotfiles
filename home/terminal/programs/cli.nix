{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # archives
      zip
      unzip
      # downloading
      wget
      ;
  };
}
