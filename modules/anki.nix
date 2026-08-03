{
  flake.modules.homeManager.anki = { config, ... }: {
    sops.secrets = {
      anki-username.sopsFile = ../secrets/user/anki.yaml;
      anki-key.sopsFile = ../secrets/user/anki.yaml;
    };

    programs.anki = {
      enable = true;
      profiles."User 1" = {
        default = true;
        sync = {
          autoSync = true;
          usernameFile = config.sops.secrets.anki-username.path;
          keyFile = config.sops.secrets.anki-key.path;
        };
      };
    };
  };
}
