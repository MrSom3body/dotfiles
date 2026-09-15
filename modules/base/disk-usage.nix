{ lib, config, ... }:
let
  inherit (config) flake;
in
{
  flake.modules.nixos.nixos = {
    programs = {
      command-not-found.enable = false;

      nano.enable = false;
    };

    services.speechd.enable = false;

    environment.defaultPackages = lib.mkForce [ ];

    system = {
      disableInstallerTools = lib.mkIf (flake.lib.isInstall config) true;
      tools = {
        nixos-version.enable = true;
        nixos-rebuild.enable = true;
      };
    };
  };
}
