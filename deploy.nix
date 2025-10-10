{ inputs, ... }:
let
  inherit (inputs) deploy-rs;
in
{
  flake = {
    deploy.nodes = {
      pandora = {
        hostname = "pandora";
        profiles.system = {
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.pandora;
        };
      };
    };
  };

  perSystem =
    { system, ... }:
    {
      checks = deploy-rs.lib.${system}.deployChecks inputs.self.deploy;
    };
}
