{
  flake.modules.nixos.arr =
    { config, ... }:
    {
      sops = {
        secrets.transmission-password.sopsFile = ../../secrets/pandora/secrets.yaml;

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
          settings = {
            bind-address-ipv4 = "10.2.0.2";
            rpc-authentication-required = true;
            download-dir = "/media/torrents";
          };

          credentialsFile = config.sops.templates."transmission.json".path;
        };
      };
    };
}
