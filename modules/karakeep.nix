# { config, ... }:
# let
#   flakeModules = config.flake.modules;
# in
{
  flake.modules.nixos.karakeep =
    { config, ... }:
    let
      cfg = config.services.karakeep;
      ollamaCfg = config.services.ollama;
    in
    {
      # import = [ flakeModules.nixos.meilisearch ];

      services = {
        caddy.virtualHosts = {
          "karakeep.sndh.dev" = {
            extraConfig = ''
              reverse_proxy ${cfg.extraEnvironment.NEXTAUTH_URL}
              import cloudflare
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
            NEXTAUTH_URL = "http://localhost:3000";
            DISABLE_SIGNUPS = "true";
            DISABLE_NEW_RELEASE_CHECK = "true";
            DB_WAL_MODE = "true";

            # ai
            OLLAMA_BASE_URL = "http://${ollamaCfg.host}:${builtins.toString ollamaCfg.port}";
            INFERENCE_TEXT_MODEL = "gemma3:latest";
            INFERENCE_IMAGE_MODEL = "gemma3:latest";
          };
        };
      };
    };
}
