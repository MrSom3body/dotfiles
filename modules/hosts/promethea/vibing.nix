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
            imports = [ flakeConfig.flake.modules.nixos.ollama ];

            services.ollama = {
              package = pkgs.ollama-rocm;
              loadModels = [ "gemma4:26b-a4b-it-q4_K_M" ];
              rocmOverrideGfx = "10.3.0";
              environmentVariables.OLLAMA_CONTEXT_LENGTH = "32768";
            };
          };
        };
    };
  };
}
