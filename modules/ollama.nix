{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.ollama = {
    services.ollama = {
      enable = true;
      syncModels = true;
      port = meta.services.karakeep.port;
    };
  };
}
