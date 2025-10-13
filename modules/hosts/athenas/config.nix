{
  flake.modules.nixos."hosts/athenas-iso" = {
    boot.supportedFilesystems = [ "ntfs" ]; # allow mounting windows

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
