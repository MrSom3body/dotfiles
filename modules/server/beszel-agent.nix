{
  flake.modules.nixos.server =
    { config, ... }:
    {
      sops.secrets.beszel = {
        sopsFile = ../../secrets/beszel.env;
        format = "dotenv";
      };

      services.beszel.agent = {
        enable = true;
        environmentFile = config.sops.secrets.beszel.path;
      };
    };
}
