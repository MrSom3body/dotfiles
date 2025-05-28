{
  lib,
  config,
  ...
}: {
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_AT.UTF-8";
      LC_COLLATE = "de_AT.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_NAME = "de_AT.UTF-8";
      LC_NUMERIC = "de_AT.UTF-8";
      LC_PAPER = "de_AT.UTF-8";
      LC_TELEPHONE = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
    };
  };

  console.useXkbConfig = true;
  services = {
    xserver.xkb.layout = "at";
    localtimed.enable = config.services.geoclue2.enable or false; # automatic timezone switching
  };

  time.timeZone = lib.mkDefault "Europe/Vienna";
}
