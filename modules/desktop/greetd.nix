{
  flake.modules.nixos.desktop = {
    services = {
      greetd = {
        enable = true;
        settings = {
          terminal.vt = 1;
        };
      };

      displayManager.regreet = {
        enable = true;
        settings.skip_selection = true;
      };
    };

    security.pam.services.greetd.fprintAuth = false;
    security.pam.services.greetd-password.fprintAuth = false;
  };
}
