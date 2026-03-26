{ inputs, ... }:
{
  flake.modules.nixos.nixos = {
    imports = [ inputs.srvos.nixosModules.common ];
  };
}
