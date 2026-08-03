{ inputs, ... }: {
  flake.modules.nixos.hermes-agent =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      imports = [ inputs.hermes-agent.nixosModules.default ];

      sops.secrets.hermes-env = {
        sopsFile = ../secrets/${hostName}/hermes.yaml;
        owner = "hermes";
        group = "hermes";
        mode = "0440";
      };

      users.users.karun.extraGroups = [ "hermes" ];

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
