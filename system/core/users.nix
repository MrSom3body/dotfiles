{
  config,
  pkgs,
  settings,
  ...
}: {
  users = {
    mutableUsers = false;
    users.${settings.user} = {
      isNormalUser = true;
      description = settings.username;
      shell = pkgs.fish;
      hashedPasswordFile = config.sops.secrets.karun-password.path;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
        "wireshark"
      ];
    };
  };

  sops.secrets.karun-password.neededForUsers = true;
}
