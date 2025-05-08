{
  inputs,
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../common/profiles/server.nix

      ../common/optional/services/tailscale-exit-node.nix

      ../common/optional/network/tuxshare.nix

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

  networking = {
    firewall.allowedTCPPorts = [80 443];
    interfaces.eno1.wakeOnLan.enable = true;
  };

  hardware = {
    intelgpu = {
      enableHybridCodec = true;
    };

    graphics.extraPackages = with pkgs; [
      intel-compute-runtime-legacy1
      intel-media-sdk
      libva-vdpau-driver
    ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "i965";
  systemd.services.immich.environment.LIBVA_DRIVER_NAME = "i965";

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
