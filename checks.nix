{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { system, ... }:
    {
      pre-commit.settings = {
        src = ../.;
        excludes = [ "hardware-configuration.nix" ];
        hooks = {
          treefmt.enable = true;

          # nix
          nil.enable = true;

          # markdown
          markdownlint = {
            enable = true;
            settings.configuration = {
              MD013 = false;
              no-inline-html = false;
            };
          };
        };
      };

      checks =
        let
          deployChecks = builtins.mapAttrs (
            _: deployLib: deployLib.deployChecks inputs.self.deploy
          ) inputs.deploy-rs.lib;
        in
        deployChecks.${system};
    };
}
