{
  flake.modules = {
    nixos.desktop = {
      networking.firewall =
        let
          ports = [
            22000
            21027
          ];
        in
        {
          allowedTCPPorts = ports;
          allowedUDPPorts = ports;
        };
    };

    homeManager.desktop = {
      services.syncthing = {
        enable = true;
        settings.options = {
          localAnnounceEnabled = false;
          globalAnnounceEnabled = false;
          natEnabled = false;
          relaysEnabled = false;
        };
      };
    };
  };
}
