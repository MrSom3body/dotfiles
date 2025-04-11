{
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
    };
  };

  programs.regreet = {
    enable = true;
  };

  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
