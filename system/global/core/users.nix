{
  lib,
  config,
  pkgs,
  settings,
  isInstall,
  ...
}: {
  users = {
    mutableUsers = !isInstall;
    users = {
      karun = {
        isNormalUser = true;
        description = "Karun Sandhu";
        shell = pkgs.fish;
        hashedPasswordFile = lib.mkIf isInstall config.sops.secrets.karun-password.path;
        extraGroups = [
          "wheel"
          "input"
          "networkmanager"
          "wireshark"
        ];
        openssh.authorizedKeys.keys = settings.authorizedSshKeys;
      };

      nixos = lib.mkIf (!isInstall) {shell = pkgs.fish;};

      root = {
        hashedPassword = null;
        openssh.authorizedKeys.keys = settings.authorizedSshKeys;
      };
    };
  };
}
