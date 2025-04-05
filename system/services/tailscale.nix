{config, ...}: {
  sops.secrets.tailscale-key.sopsFile = ../../secrets/${config.networking.hostName}/secrets.yaml;

  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-key.path;
    };
  };
}
