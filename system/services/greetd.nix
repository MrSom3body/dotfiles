{
  config,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      initial_session = {
        command = "${lib.getExe config.programs.hyprland.package}";
        user = "karun";
      };
    };
  };

  programs.regreet = {
    enable = true;
  };

  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
