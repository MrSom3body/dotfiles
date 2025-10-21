{ inputs, ... }:
{
  flake.modules.nixos."hosts/promethea" = {
    imports = [ inputs.nixos-hardware.nixosModules.asus-zenbook-um6702 ];

    boot.kernelParams = [ "amdgpu.dcdebugmask=0x40000" ];
    hardware.asus.battery.chargeUpto = 80;
    security.tpm2.enable = true;
  };
}
