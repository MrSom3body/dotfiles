{ config, ... }:
{
  flake.modules.homeManager.homeManager =
    { pkgs, ... }:
    {
      programs = {
        gpg = {
          enable = true;
          settings = {
            default-key = config.flake.meta.users.karun.key;
            keyserver = "hkps://keys.openpgp.org";
          };
        };
        wayprompt.enable = true;
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.wayprompt;
      };
    };
}
