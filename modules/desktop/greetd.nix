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

    programs.regreet = {
      enable = true;
    };
  };
}
