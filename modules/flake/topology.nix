{ inputs, ... }:
{
  imports = [ inputs.nix-topology.flakeModule ];

  perSystem.topology.modules = [
    (
      { config, ... }:
      let
        inherit (config.lib.topology) mkInternet mkConnection mkRouter;
      in
      {
        nodes = {
          internet = mkInternet {
            connections = [
              (mkConnection "router" "eth0")
              (mkConnection "xylourgos" "eth0")
            ];
          };

          intranet =
            mkInternet {
              connections = map (device: mkConnection device "tailscale0") [
                "pandora"
                "promethea"
                "xylourgos"
              ];
            }
            // {
              name = "som3net";
            };

          router = mkRouter "router" {
            hardware.info = "The gateway to the world, may or may not be guarded by a three-headed dog.";
            interfaceGroups = [
              [ "eth0" ] # WAN
              [ "eth1" ] # LAN
              [ "eth2" ] # LAN
              [ "wlan0" ] # WLAN
            ];
            interfaces = {
              eth1.network = "LAN";
              eth2.network = "LAN";
              wlan0.network = "WLAN";
            };
            connections = {
              eth1 = mkConnection "pandora" "eno1";
              eth2 = mkConnection "promethea" "eth0";
              wlan0 = mkConnection "promethea" "wlan0";
            };
          };

          pandora = {
            hardware.info = "An old PC that was given a new life as a server. It might not have brought hope to mankind, but it serves files pretty well.";
            interfaces = {
              eno1 = { };
              tailscale0 = { };
            };
          };

          promethea = {
            hardware.info = "The laptop that took the red pill and entered the world of NixOS.";
            interfaces = {
              wlan0 = { };
              eth0 = { };
              tailscale0 = { };
            };
          };

          xylourgos = {
            hardware.info = "A free-tier Oracle Ampere instance, proving that the best things in life (and cloud) are free.";
            interfaces = {
              eth0 = { };
              tailscale0 = { };
            };
          };
        };

        networks = {
          LAN = {
            name = "LAN";
            cidrv4 = "10.0.0.0/24";
          };
          WLAN = {
            name = "WLAN";
            cidrv4 = "10.0.0.0/24";
          };
        };
      }
    )
  ];
}
