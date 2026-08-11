{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.cryptgeon = { config, ... }: {
    services = {
      cloudflared.tunnels.${config.networking.hostName}.ingress."${meta.services.cryptgeon.domain}" =
        "http://localhost:${toString meta.services.cryptgeon.port}";

      caddy.virtualHosts.${meta.services.cryptgeon.domain}.extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString meta.services.cryptgeon.port}
      '';

      redis.servers.cryptgeon = {
        enable = true;
        save = [ ];
        extraParams = [
          "--maxmemory 4gb"
          "--maxmemory-policy allkeys-lru"
        ];
      };
    };

    virtualisation.oci-containers.containers.cryptgeon = {
      image = "docker.io/cupcakearmy/cryptgeon:latest";
      environment = {
        THEME_PAGE_TITLE = "Karun's Cryptgeon";

        SIZE_LIMIT = "512 MiB";
        REDIS = "redis+unix:///run/redis.sock";
      };
      volumes = [ "${config.services.redis.servers.cryptgeon.unixSocket}:/run/redis.sock" ];
      ports = [ "127.0.0.1:${toString meta.services.cryptgeon.port}:8000" ];
    };

    systemd.services.podman-cryptgeon = {
      requires = [ "redis-cryptgeon.service" ];
      after = [ "redis-cryptgeon.service" ];
    };
  };
}
