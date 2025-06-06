{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../system/profiles/server.nix

    ../../system/optional/services/tailscale-exit-node.nix

    ../../system/optional/network/tuxshare.nix

    ./services/caddy.nix
    ./services/ddns-updater.nix
    ./services/glance.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/send.nix

    ./vpn/proton.nix

    inputs.nixos-hardware.nixosModules.common-pc
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

    graphics.extraPackages = builtins.attrValues {
      inherit
        (pkgs)
        intel-compute-runtime-legacy1
        intel-media-sdk
        libva-vdpau-driver
        ;
    };
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "i965";
  systemd.services.immich.environment.LIBVA_DRIVER_NAME = "i965";

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
