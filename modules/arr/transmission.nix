{
  flake.modules.nixos.arr =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      sops = {
        secrets.transmission-password.sopsFile = ../../secrets/${hostName}/transmission.yaml;

        templates."transmission.json" = {
          owner = "transmission";
          content =
            #json
            ''
              {
                "rpc-password": "${config.sops.placeholder.transmission-password}"
              }
            '';
        };
      };

      services = {
        transmission = {
          group = "arr";
          settings = {
            bind-address-ipv4 = "10.2.0.2";
            bind-address-ipv6 = "::1";
            rpc-authentication-required = true;
            download-dir = "/media/torrents";
            incomplete-dir = "/media/torrents/.incomplete";
            incomplete-dir-enabled = true;
          };

          credentialsFile = config.sops.templates."transmission.json".path;
        };
      };
    };
}
