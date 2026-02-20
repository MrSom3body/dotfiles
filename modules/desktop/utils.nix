{ self, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages =
        builtins.attrValues {
          inherit (pkgs)
            # gui
            gnome-calculator
            gnome-clocks
            gnome-disk-utility
            hyprpicker
            nautilus
            pwvucontrol
            snapshot # Camera App
            # cli
            brightnessctl
            libnotify # notification
            ripdrag # to drag files out of the terminal
            wl-clipboard
            wtype
            ;
        }
        # my packages
        ++ builtins.attrValues {
          inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) hyprcast touchpad-toggle wl-ocr;
        };
    };
}
