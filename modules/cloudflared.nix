{
  flake.modules.nixos.cloudflared =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      sops.secrets.cloudflared-credentials = {
        sopsFile = ../secrets/${hostName}/cloudflared.yaml;
        format = "yaml";
      };

      services.cloudflared = {
        enable = true;
        tunnels.${hostName} = {
          credentialsFile = config.sops.secrets.cloudflared-credentials.path;
          default = "http_status:404";
        };
      };
    };
}
