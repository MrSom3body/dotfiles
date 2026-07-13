{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = [ pkgs.wiremix ];
    xdg.configFile."wiremix/wiremix.toml".source = (pkgs.formats.toml { }).generate "wiremix.toml" {
      max_volume_percent = 100.0;
      enforce_max_volume = false;
    };
  };
}
