{pkgs, ...}: {
  home.packages = [pkgs.tokei];

  xdg.configFile."tokei.toml".text =
    # toml
    ''
      sort = "lines"
    '';
}
