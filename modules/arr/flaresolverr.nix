{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.arr = { config, ... }: {
    virtualisation.oci-containers.containers.flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      labels."io.containers.autoupdate" = "registry";
      ports = [ "127.0.0.1:${toString meta.services.flaresolverr.port}:8191" ];
      environment = {
        TZ = config.time.timeZone;
      };
    };
  };
}
