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
  };
in
{
  flake.modules = {
    nixos.nixos =
      { config, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];
        config = lib.mkIf (flake.lib.isInstall config) {
          sops = sopsDefaults // {
            age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            secrets.karun-password.neededForUsers = true;
          };
        };
      };

    homeManager.homeManager =
      { config, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];
        config = lib.mkIf (flake.lib.isInstall config) {
          sops = sopsDefaults // {
            gnupg.home = "~/.gnupg";
          };
        };
      };
  };
}
