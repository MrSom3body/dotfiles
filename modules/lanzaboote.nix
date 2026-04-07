{ inputs, ... }:
{
  flake.modules.nixos.lanzaboote =
    { pkgs, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/secureboot";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          # autoReboot = true; # TODO uncomment when https://github.com/nix-community/lanzaboote/issues/569 gets fixed
        };
      };

      environment.systemPackages = [ pkgs.sbctl ];
    };
}
