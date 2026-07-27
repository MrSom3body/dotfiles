{ config, ... }: {
  flake.modules.homeManager.homeManager = { pkgs, lib, ... }: {
    programs = {
      gpg = {
        enable = true;
        settings = {
          default-key = config.flake.meta.users.karun.key;
          keyserver = "hkps://keys.openpgp.org";
        };
      };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = lib.mkDefault pkgs.pinentry-curses;

      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;
      defaultCacheTtlSsh = 1800;
      maxCacheTtlSsh = 7200;
    };
  };
}
