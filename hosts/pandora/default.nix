{inputs, ...}: {
  imports =
    [
      ./hardware-configuration.nix
      ../common/profiles/server.nix

      ../common/optional/services/tailscale-exit-node.nix

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
  security.tpm2.enable = true;
  powerManagement.enable = true;
}
