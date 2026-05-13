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

    services.accounts-daemon.enable = true; # TODO remove when https://github.com/NixOS/nixpkgs/pull/519416 lands in unstable
  };
}
