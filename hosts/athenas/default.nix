{
  imports = [
    ../../system/profiles/iso.nix

    ../../system/profiles/laptop.nix
  ];

  my.home-manager.enable = true;

  boot.supportedFilesystems = [ "ntfs" ]; # allow mounting windows

  nixpkgs.hostPlatform = "x86_64-linux";
}
