{ lib, inputs, ... }:
let
  sopsDefaults = {
    defaultSopsFile = ../../secrets/global.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
  };
in
{
  flake.modules = {
    nixos.base =
      { hostConfig, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];
        config = lib.mkIf hostConfig.isInstall {
          sops = sopsDefaults // {
            age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            secrets.karun-password.neededForUsers = true;
          };
        };
      };

    homeManager.base =
      { hostConfig, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];
        config = lib.mkIf hostConfig.isInstall {
          sops = sopsDefaults // {
            gnupg.home = "~/.gnupg";
          };
        };
      };
  };
}
