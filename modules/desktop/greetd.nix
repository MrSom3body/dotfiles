{
  flake.modules.nixos.desktop = {
    services = {
      greetd = {
        enable = true;
        settings = {
          terminal.vt = 1;
        };
      };
    };

    security.pam.services.greetd.fprintAuth = false;
    security.pam.services.greetd-password.fprintAuth = false;

    programs.regreet = {
      enable = true;
    };
  };
}
