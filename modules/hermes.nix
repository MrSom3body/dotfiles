{ inputs, ... }:
{
  flake.modules.nixos.hermes =
    { config, ... }:
    {
      imports = [ inputs.hermes-agent.nixosModules.default ];

      sops.secrets.hermes-env = {
        sopsFile = ../secrets/hermes.yaml;
        owner = "hermes";
        group = "hermes";
      };

      services.hermes-agent = {
        enable = true;
        settings.model = {
          provider = "custom";
          base_url = "http://localhost:11434/v1";
          context_length = 32768;
        };
        environmentFiles = [ config.sops.secrets."hermes-env".path ];
        addToSystemPackages = true;
      };
    };
}
