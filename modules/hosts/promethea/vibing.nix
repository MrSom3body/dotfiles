{ config, ... }:
let
  flakeConfig = config;
in
{
  flake = {
    modules = {
      nixos."hosts/promethea" =
        { pkgs, ... }:
        {
          specialisation.vibing.configuration = {
            environment.etc."specialisation".text = "vibing"; # for nh
            system.nixos.tags = [ "vibing" ]; # to display it in the boot loader
            imports = [
              flakeConfig.flake.modules.nixos.ollama
              flakeConfig.flake.modules.nixos.hermes-agent
            ];

            services = {
              ollama = {
                package = pkgs.ollama-rocm;
                loadModels = [
                  "gemma4:e4b"
                  "gemma4:26b"
                ];
                rocmOverrideGfx = "10.3.0";
                environmentVariables = {
                  OLLAMA_CONTEXT_LENGTH = "16384";
                  OLLAMA_FLASH_ATTENTION = "1";
                  OLLAMA_KV_CACHE_TYPE = "q8_0";
                };
              };

              hermes-agent = {
                settings = {
                  model.default = "gemma4:e4b";
                };
              };
            };
          };
        };
    };
  };
}
