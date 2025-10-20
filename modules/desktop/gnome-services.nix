{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      services = {
        # needed for GNOME services outside of GNOME Desktop
        dbus.packages = builtins.attrValues {
          inherit (pkgs)
            gcr
            gnome-settings-daemon
            ;
        };

        gnome.gnome-keyring.enable = true;

        gvfs.enable = true;
      };

      # unlock GPG keyring on login
      security.pam.services.greetd.enableGnomeKeyring = true;
    };
}
