{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets/global.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
  };
}
