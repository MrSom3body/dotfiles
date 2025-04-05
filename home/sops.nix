{inputs, ...}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets/global.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;
    age.sshKeyPaths = ["/home/karun/.ssh/id_ed25519"];
  };
}
