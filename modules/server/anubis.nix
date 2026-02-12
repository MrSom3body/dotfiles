{
  flake.modules.nixos.server =
    { config, ... }:
    let
      cfg = config.services.anubis.defaultOptions;
      caddyCfg = config.services.caddy;
    in
    {
      users.users."${caddyCfg.user}".extraGroups = [ cfg.group ];
    };
}
