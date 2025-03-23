{
  inputs,
  settings,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
    {
      sops = {
        defaultSopsFile = ../../secrets/global.yaml;
        defaultSopsFormat = "yaml";
        validateSopsFiles = true;
        age.sshKeyPaths = ["/home/${settings.user}/.ssh/id_ed25519"];
      };
    }
  ];

  sops = {
    defaultSopsFile = ../../secrets/global.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
