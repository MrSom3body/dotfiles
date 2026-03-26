{
  flake.modules.nixos.server =
    { lib, ... }:
    {
      networking = {
        firewall = {
          enable = lib.mkForce true;
          allowedTCPPorts = [
            80
            443
          ];
        };
      };
    };
}
