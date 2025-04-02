{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  imports =
    [
      ../../system/profiles/server.nix
      ./hardware-configuration.nix

      ../../system/services/tailscale.nix

      ./services/caddy.nix
      ./services/ddns-updater.nix
      ./services/glance.nix
      ./services/immich.nix
      ./services/jellyfin.nix
      ./services/send.nix

      ./vpn/proton.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc
    ])
    ++ [
      (inputs.nixos-hardware + "/common/cpu/intel/haswell")
    ];

  services = {
    tailscale = {
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--advertise-exit-node"
        "--advertise-routes \"10.0.0.10/32\""
      ];
    };

    networkd-dispatcher = lib.optionalAttrs (config.services.tailscale.useRoutingFeatures == "server") {
      enable = true;
      rules."50-tailscale" = {
        onState = ["routable"];
        script = ''
          ${lib.getExe pkgs.ethtool} -K eno1 rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };

  networking = {
    firewall.allowedTCPPorts = [80 443];
    interfaces.eno1.wakeOnLan.enable = true;
  };
  security.tpm2.enable = true;
  powerManagement.enable = true;
}
