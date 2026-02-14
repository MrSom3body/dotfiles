# { config, ... }:
# let
#   flakeModules = config.flake.modules;
# in
{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.karakeep =
    { config, ... }:
    let
      ollamaCfg = config.services.ollama;
    in
    {
      # import = [ flakeModules.nixos.meilisearch ];

      services = {
        caddy.virtualHosts = {
          "${meta.services.karakeep.domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${meta.services.karakeep.port}
            '';
          };
        };

        ollama = {
          enable = true;
          loadModels = [ "gemma3:latest" ];
        };

        karakeep = {
          enable = true;
          meilisearch.enable = false;
          extraEnvironment = {
            NEXTAUTH_URL = "http://localhost:${ollamaCfg.port}";
            DISABLE_SIGNUPS = "true";
            DISABLE_NEW_RELEASE_CHECK = "true";
            DB_WAL_MODE = "true";

            # ai
            OLLAMA_BASE_URL = "http://localhost:${ollamaCfg.port}";
            INFERENCE_TEXT_MODEL = "gemma3:latest";
            INFERENCE_IMAGE_MODEL = "gemma3:latest";
          };
        };
      };
    };
}
