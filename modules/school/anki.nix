{
  flake.modules.homeManager.school =
    { config, ... }:
    {
      sops.secrets = {
        anki-username.sopsFile = ../../secrets/anki.yaml;
        anki-key.sopsFile = ../../secrets/anki.yaml;
      };

      programs.anki = {
        enable = true;
        sync = {
          autoSync = true;
          usernameFile = config.sops.secrets.anki-username.path;
          keyFile = config.sops.secrets.anki-key.path;
        };
      };
    };
}
