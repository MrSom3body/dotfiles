{ lib, ... }:
{
  flake.modules.nixos.emulation =
    { pkgs, ... }:
    {
      # allows building for other architectures
      boot.binfmt.emulatedSystems = lib.filter (system: system != pkgs.stdenv.hostPlatform.system) [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
      ];
    };
}
