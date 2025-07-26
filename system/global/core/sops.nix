{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.sops;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.my.sops = {
    enable = mkEnableOption "sops config" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../../secrets/global.yaml;
      defaultSopsFormat = "yaml";
      validateSopsFiles = true;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      secrets.karun-password.neededForUsers = true;
    };
  };
}
