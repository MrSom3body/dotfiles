{
  lib,
  config,
  ...
}:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos = {
    nixos =
      { config, pkgs, ... }:
      {
        users = {
          mutableUsers = false;
          users = {
            karun = {
              isNormalUser = true;
              description = "Karun Sandhu";
              shell = pkgs.fish;
              hashedPasswordFile = config.sops.secrets.karun-password.path or null;
              extraGroups = [
                "wheel"
                "input"
              ];
              openssh.authorizedKeys.keys = meta.users.karun.authorizedKeys;
            };

            root = {
              openssh.authorizedKeys.keys = meta.users.karun.authorizedKeys;
            };
          };
        };
      };

    iso = {
      users = {
        mutableUsers = lib.mkForce true;
        users = {
          karun = {
            initialHashedPassword = "";
          };
          root = {
            initialHashedPassword = lib.mkForce "";
          };
        };
      };
    };
  };
}
