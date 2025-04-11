{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../common/profiles/server.nix

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
      useRoutingFeatures = "both";
      extraUpFlags = [
        "--advertise-exit-node"
        ''--advertise-routes "10.0.0.10/32,10.0.0.11/32,10.0.0.12/32"''
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
