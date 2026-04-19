{
  flake.modules = {
    homeManager.desktop =
      { config, ... }:
      {
        programs.password-store = {
          enable = true;
          settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
        };

        services.pass-secret-service = {
          enable = true;
        };
      };
  };
}
