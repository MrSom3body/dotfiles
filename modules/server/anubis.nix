{
  flake.modules.nixos.server =
    { lib, config, ... }:
    let
      cfg = config.services.anubis.defaultOptions;
    in
    {
      config = lib.mkIf (config.services.anubis.instances != { }) {
        users.users."${config.services.caddy.user}".extraGroups = [ cfg.group ];

        systemd.services = lib.mapAttrs' (
          name: _:
          lib.nameValuePair "cloudflared-tunnel-${name}" {
            serviceConfig.SupplementaryGroups = [ cfg.group ];
          }
        ) config.services.cloudflared.tunnels;
      };
    };
}
