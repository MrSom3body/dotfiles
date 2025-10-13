{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          # gui
          baobab # Disk Usage Analyzer
          gnome-calculator
          gnome-clocks
          gnome-disk-utility
          gnome-weather
          snapshot # Camera App
          # cli
          libnotify # notification
          ripdrag # to drag files out of the terminal
          ;
      };
    };
}
