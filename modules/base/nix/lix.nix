{ inputs, ... }: {
  flake.modules.nixos.nixos = {
    imports = [ inputs.lix-module.nixosModules.default ];
  };
}
