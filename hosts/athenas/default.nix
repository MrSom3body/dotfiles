{
  imports = [
    ../../system/profiles/iso.nix
    ../../system/global/programs/home-manager.nix

    ../../system/profiles/laptop.nix
  ];

  boot.supportedFilesystems = ["ntfs"]; # allow mounting windows

  nixpkgs.hostPlatform = "x86_64-linux";
}
