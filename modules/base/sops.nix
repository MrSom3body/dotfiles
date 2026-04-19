{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (config) flake;
  sopsDefaults = {
    defaultSopsFile = ../../secrets/global.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
    age.generateKey = true;
  };
in
{
  flake.modules = {
    nixos.nixos =
      { config, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];
        config = lib.mkIf (flake.lib.isInstall config) {
          sops = lib.recursiveUpdate sopsDefaults {
            age = {
              keyFile = "/etc/sops/age/keys.txt";
              sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            };
            secrets.karun-password.neededForUsers = true;
          };
        };
      };

    homeManager.homeManager =
      { config, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];
        config = lib.mkIf (flake.lib.isInstall config) {
          sops = lib.recursiveUpdate sopsDefaults {
            age = {
              keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
              sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
            };
          };
        };
      };
  };
}
