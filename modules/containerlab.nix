{ config, ... }:
{
  flake.modules.nixos.containerlab =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.nixos.podman
      ];

      environment = {
        systemPackages = [ pkgs.containerlab ];
        shellAliases = {
          clab = "containerlab";
        };
      };
    };
}
