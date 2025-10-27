{
  flake.modules.nixos.desktop = {
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      greetd-password.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
  };
}
