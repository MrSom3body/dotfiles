{ config, ... }:
let
  inherit (config.flake) meta;
  flakeModules = config.flake.modules;
in
{
  flake.modules.nixos.karakeep =
    { config, ... }:
    let
      ollamaCfg = config.services.ollama;
      llmModel = "gemma4:e2b";
    in
    {
      imports = [ flakeModules.nixos.ollama ];

      services = {
        caddy.virtualHosts = {
          "${meta.services.karakeep.domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${toString meta.services.karakeep.port}
            '';
          };
        };

        ollama.loadModels = [ llmModel ];

        karakeep = {
          enable = true;
          extraEnvironment = {
            PORT = toString meta.services.karakeep.port;
            NEXTAUTH_URL = "http://localhost:${toString meta.services.karakeep.port}";
            DISABLE_SIGNUPS = "true";
            DISABLE_NEW_RELEASE_CHECK = "true";
            DB_WAL_MODE = "true";

            # ai
            OLLAMA_BASE_URL = "http://localhost:${toString ollamaCfg.port}";
            INFERENCE_TEXT_MODEL = llmModel;
            INFERENCE_IMAGE_MODEL = llmModel;
          };
        };
      };
    };
}
