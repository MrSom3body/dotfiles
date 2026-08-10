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

      # TODO remove when https://nixpk.gs/pr-tracker.html?pr=549487 lands in unstable
      systemd.services.meilisearch.serviceConfig.ExecStartPre = pkgs.lib.mkAfter [
        "${pkgs.gnused}/bin/sed -i '/experimental_dumpless_upgrade/d' \${RUNTIME_DIRECTORY}/config.toml"
      ];

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
          package = pkgs.karakeep;
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
