{
  lib,
  isInstall,
  ...
}: {
  services = {
    tailscale = {
      enable = isInstall;
      useRoutingFeatures = lib.mkDefault "client";
    };
  };
}
