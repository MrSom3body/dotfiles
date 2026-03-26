{ inputs, ... }:
{
  flake.modules.nixos.desktop = {
    imports = [ inputs.srvos.nixosModules.desktop ];
  };
}
