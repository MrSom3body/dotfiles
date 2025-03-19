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

      ../../system/services/glance.nix
      ../../system/services/immich.nix
      ../../system/services/tailscale.nix

      ./services/caddy.nix
      ./services/ddns-updater.nix
      ./services/send.nix
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

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
