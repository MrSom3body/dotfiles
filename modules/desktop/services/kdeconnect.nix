{
  flake.modules = {
    nixos.desktop =
      let
        portRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
      in
      {
        networking.firewall = {
          allowedTCPPortRanges = portRanges;
          allowedUDPPortRanges = portRanges;
        };
      };

    homeManager.desktop =
      { pkgs, ... }:
      {
        services.kdeconnect = {
          enable = true;
          package = pkgs.kdePackages.kdeconnect-kde;
          indicator = true;
        };
      };
  };
}
