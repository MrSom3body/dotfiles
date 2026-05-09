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
          autoReboot = true;
        };
      };

      environment.systemPackages = [ pkgs.sbctl ];
    };
}
