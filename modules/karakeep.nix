{ config, ... }:
let
  inherit (config.flake) meta;
  flakeModules = config.flake.modules;
in
{
  flake.modules.nixos.karakeep =
    { config, pkgs, ... }:
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
          # TODO remove when https://github.com/NixOS/nixpkgs/issues/529285 gets resolved for karakeep
          package = pkgs.stable.karakeep;
          extraEnvironment = {
            PORT = toString meta.services.karakeep.port;
            NEXTAUTH_URL = "https://${meta.services.karakeep.domain}";
            DISABLE_SIGNUPS = "true";
            DISABLE_NEW_RELEASE_CHECK = "true";
            DB_WAL_MODE = "true";

            # ai
            OPENAI_API_KEY = "ollama";
            OPENAI_BASE_URL = "http://127.0.0.1:${toString ollamaCfg.port}/v1";
            INFERENCE_TEXT_MODEL = llmModel;
            INFERENCE_IMAGE_MODEL = llmModel;
          };
        };
      };
    };
}
