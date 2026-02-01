{
  flake.modules.nixos.qemu-guest =
    { modulesPath, ... }:
    {
      imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
    };
}
