{
  lib,
  settings,
  ...
}: {
  imports = [
    ./boot.nix
    ./security.nix
    ./users.nix

    ../nix
    ../programs/fish.nix
  ];

  documentation.dev.enable = true;

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

  time.timeZone = lib.mkDefault "Europe/Vienna";

  services.localtimed.enable = true; # automatic timezone switching

  networking.hostName = settings.hostname;

  console.keyMap = "de";

  # compresses half the ram for use as swap
  zramSwap.enable = true;

  # don't touch this
  system.stateVersion = lib.mkForce "24.05";
}
