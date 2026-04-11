{ inputs, ... }:
{
  flake.modules.nixos.hermes-agent =
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
          base_url = "http://127.0.0.1:11434/v1";
        };
        environmentFiles = [ config.sops.secrets."hermes-env".path ];
        addToSystemPackages = true;
      };
    };
}
