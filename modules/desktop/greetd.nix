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

    programs.regreet = {
      enable = true;
    };
  };
}
