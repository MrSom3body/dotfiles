{ inputs, ... }:
{
  flake.modules.nixos.lanzaboote =
    { pkgs, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };

      environment.systemPackages = [ pkgs.sbctl ];
    };
}
