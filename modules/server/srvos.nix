{ inputs, ... }:
{
  flake.modules.nixos.server = {
    imports = [ inputs.srvos.nixosModules.server ];
  };
}
