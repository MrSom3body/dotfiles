{
  flake.modules.nixos.desktop = {
    services.gnome.gnome-keyring.enable = true;

    # unlock GPG keyring on login
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
