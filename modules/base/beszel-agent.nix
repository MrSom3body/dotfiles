{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.nixos = { config, ... }: {
    sops.secrets.beszel = {
      sopsFile = ../../secrets/beszel.env;
      format = "dotenv";
    };

    services.beszel.agent = {
      enable = true;
      environment.BESZEL_AGENT_HUB_URL = "https://${meta.services.beszel.domain}";
      environmentFile = config.sops.secrets.beszel.path;
    };
  };
}
