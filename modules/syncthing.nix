{ config, ... }:
let
  inherit (config.flake) meta;
  mkDevices =
    devList:
    builtins.listToAttrs (
      map (d: {
        inherit (d) name;
        value = {
          inherit (d) id;
          addresses = [ "tcp://${d.name}.penguin-corn.ts.net:22000" ];
        };
      }) devList
    );

  settings = {
    options = {
      urAccepted = -1;

      localAnnounceEnabled = false;
      globalAnnounceEnabled = false;
      natEnabled = false;
      relaysEnabled = false;
    };

    devices = mkDevices [
      # desktops
      {
        name = "promethea";
        id = "AP5MA4O-QAA6MHI-QWUVRGD-TBORCCJ-UVZ336J-3KDDMVZ-EBFWUIZ-NXJ3AQ5";
      }

      # servers
      {
        name = "pandora";
        id = "XKOR3CJ-HOQSIWH-XQKWRUB-T27KGOS-XESAN7M-AMAC7DH-CYPY6CG-TH4J3QO";
      }
      {
        name = "xylourgos";
        id = "UFSTMXQ-FEVYXA6-6LZ2MMZ-4XPMNUZ-CU3ZBIU-FREXNLD-65C4UY3-TKGK5Q2";
      }

      # phones
      {
        name = "Pixel 9a";
        id = "A2H6SC5-G662464-OKCPF7N-DYRAJLP-6EWI7UA-XKRZFHG-52PILEC-MP3L2A4";
      }
    ];
  };
in
{
  flake.modules =
    let
      networking = {
        firewall =
          let
            firewallPorts = [
              22000
              21027
            ];
          in
          {
            allowedTCPPorts = firewallPorts;
            allowedUDPPorts = firewallPorts;
          };
      };
    in
    {
      nixos.syncthing-server =
        { config, ... }:
        {
          inherit networking;

          services = {
            syncthing = {
              enable = true;
              inherit settings;
              overrideFolders = false;
            };
            caddy.virtualHosts = {
              "syncthing.${config.networking.hostName}.${config.networking.domain}" = {
                extraConfig = ''
                  reverse_proxy http://127.0.0.1:${toString meta.services.syncthing.port} {
                    header_up Host {upstream_hostport}
                  }
                '';
              };
            };
          };
        };

      nixos.syncthing = { inherit networking; };

      homeManager.syncthing = {
        services.syncthing = {
          enable = true;
          inherit settings;
          overrideFolders = false;
        };
      };
    };
}
