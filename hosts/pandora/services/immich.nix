{config, ...}: let
  cfg = config.services.immich;
in {
  imports = [
    ../../common/optional/services/immich.nix
  ];

  sops.secrets.immich-db-password.sopsFile = ../../../secrets/pandora/secrets.yaml;

  services = {
    immich = {
      secretsFile = config.sops.secrets.immich-db-password.path;
      accelerationDevices = ["/dev/dri/renderD128"];
    };

    caddy.virtualHosts = {
      "immich.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
          import cloudflare
        '';
      };

      "media.sndh.dev" = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
          tls internal
        '';
      };
    };
  };

  # from https://wiki.nixos.org/wiki/Immich#Enabling_Hardware_Accelerated_Video_Transcoding
  users.users.immich.extraGroups = ["video" "render"];
}
