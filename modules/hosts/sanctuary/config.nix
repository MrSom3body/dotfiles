{
  flake.modules.nixos."hosts/sanctuary-iso" = {
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
