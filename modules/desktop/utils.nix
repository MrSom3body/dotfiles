{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          # gui
          gnome-calculator
          gnome-clocks
          gnome-disk-utility
          snapshot # Camera App
          # cli
          libnotify # notification
          ripdrag # to drag files out of the terminal
          ;
      };
    };
}
