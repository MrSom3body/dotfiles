{
  flake.modules.nixos."hosts/promethea" = {
    services.tailscale.extraSetFlags = [ "--accept-routes" ];
  };
}
