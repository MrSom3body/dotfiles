{ inputs, ... }: {
  flake.modules.nixos."hosts/pandora" = { ... }: {
    imports = [
      inputs.nixos-hardware.nixosModules.common-pc
      (inputs.nixos-hardware + "/common/cpu/intel/haswell")
    ];

    networking.interfaces.eno1.wakeOnLan.enable = true;
  };
}
