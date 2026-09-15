{ inputs, ... }: {
  flake.modules.nixos.nixos = {
    imports = [ inputs.nixos-core.nixosModules.default ];

    system.nixos-core = {
      enable = true;
      strictActivation = true;
    };
  };
}
