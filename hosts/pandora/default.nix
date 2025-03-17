{inputs, ...}: {
  imports =
    [
      ../../system/profiles/server.nix
      ./hardware-configuration.nix

      ../../system/services/glance.nix
      ../../system/services/minecraft.nix
      ../../system/services/openssh.nix
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

  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-exit-node"
      "--advertise-routes \"10.0.0.10/32\""
    ];
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
