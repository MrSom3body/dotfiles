{pkgs, ...}: {
  home.packages = [pkgs.dust];
  xdg.configFile."dust/config.toml".text =
    # toml
    ''
      reverse=true
    '';
}
