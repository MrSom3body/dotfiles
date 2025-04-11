{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    users.karun = {
      isNormalUser = true;
      description = "Karun Sandhu";
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
