{ config, ... }: {
  flake.modules.homeManager.homeManager = { pkgs, ... }: {
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

      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;
      defaultCacheTtlSsh = 1800;
      maxCacheTtlSsh = 7200;
    };
  };
}
