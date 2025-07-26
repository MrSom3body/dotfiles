{
  lib,
  config,
  pkgs,
  settings,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib) mkIf;
  cfg = config.my.users;
in
{
  options.my.users = {
    enable = mkEnableOption "my users" // {
      default = true;
    };
    isInstall = mkEnableOption "setting options appropriate for installs" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = cfg.isInstall;
      users = {
        karun = {
          isNormalUser = true;
          description = "Karun Sandhu";
          shell = pkgs.fish;
          initialHashedPassword = mkIf (!cfg.isInstall) "";
          hashedPasswordFile = mkIf cfg.isInstall config.sops.secrets.karun-password.path;
          extraGroups = [
            "wheel"
            "input"
          ];
          openssh.authorizedKeys.keys = settings.authorizedSshKeys;
        };

        root = {
          hashedPassword = mkIf cfg.isInstall null;
          initialHashedPassword = mkIf (!cfg.isInstall) "";
          openssh.authorizedKeys.keys = settings.authorizedSshKeys;
        };
      };
    };
  };
}
