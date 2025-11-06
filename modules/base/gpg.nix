{ config, ... }:
{
  flake.modules.homeManager.homeManager = {
    programs.gpg = {
      enable = true;
      settings = {
        default-key = config.flake.meta.users.karun.key;
        keyserver = "hkps://keys.openpgp.org";
      };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
