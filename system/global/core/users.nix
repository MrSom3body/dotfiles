{
  lib,
  config,
  pkgs,
  settings,
  isInstall,
  ...
}: {
  users = {
    mutableUsers = true;
    users = {
      karun = {
        isNormalUser = true;
        description = "Karun Sandhu";
        shell = pkgs.fish;
        hashedPasswordFile = lib.mkIf isInstall config.sops.secrets.karun-password.path;
        extraGroups = [
          "wheel"
          "input"
        ];
        openssh.authorizedKeys.keys = settings.authorizedSshKeys;
      };

      root = {
        hashedPassword = lib.mkIf isInstall null;
        openssh.authorizedKeys.keys = settings.authorizedSshKeys;
      };
    };
  };
}
