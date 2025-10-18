{ inputs, ... }:
let
  sopsDefaults = {
    defaultSopsFile = ../../secrets/global.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
  };
in
{
  flake.modules = {
    nixos.base = {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = sopsDefaults // {
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        secrets.karun-password.neededForUsers = true;
      };
    };

    homeManager.base =
      { config, ... }:
      {
        imports = [
          inputs.sops-nix.homeManagerModules.sops
        ];

        sops = sopsDefaults // {
          age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        };
      };
  };
}
