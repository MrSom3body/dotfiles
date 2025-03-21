{
  config,
  settings,
  ...
}: {
  sops.secrets.tailscale-key.sopsFile = ../../secrets/${settings.hostname}/secrets.yaml;

  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-key.path;
    };
  };
}
