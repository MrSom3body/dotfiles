{
  config,
  pkgs,
  settings,
  ...
}: {
  users = {
    mutableUsers = false;
    users = {
      karun = {
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
        openssh.authorizedKeys.keys = settings.authorizedSshKeys;
      };

      root = {
        hashedPassword = null;
        openssh.authorizedKeys.keys = settings.authorizedSshKeys;
      };
    };
  };

  sops.secrets.karun-password.neededForUsers = true;
}
