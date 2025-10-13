{
  flake.modules.nixos."hosts/pandora" =
    { config, ... }:
    {
      services.caddy = {
        virtualHosts = {
          "loxone.${config.networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://10.0.0.10
              import cloudflare
            '';
          };
        };
      };
    };
}
