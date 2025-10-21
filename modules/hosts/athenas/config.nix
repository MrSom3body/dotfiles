{
  flake.modules.nixos."iso/athenas" = {
    boot.supportedFilesystems = [ "ntfs" ]; # allow mounting windows

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
