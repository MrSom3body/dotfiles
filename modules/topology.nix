{ inputs, ... }:
{
  flake.modules.nixos.topology = {
    imports = [ inputs.nix-topology.nixosModules.default ];
  };
}
