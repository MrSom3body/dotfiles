{
  config,
  lib,
  ...
}: {
  sops.secrets.tailscale-key.sopsFile = ../../../../secrets/${config.networking.hostName}/secrets.yaml;

  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkDefault "client";
      authKeyFile = config.sops.secrets.tailscale-key.path;
    };
  };
}
