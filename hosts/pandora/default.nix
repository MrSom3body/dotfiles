{
  inputs,
  pkgs,
  ...
}: {
  imports =
    [
      ../../system/profiles/server.nix
      ./hardware-configuration.nix

      ../../system/services/minecraft.nix
      ../../system/services/openssh.nix
      ../../system/services/tailscale.nix

      ./services/caddy.nix
      ./services/send.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc
    ])
    ++ [
      (inputs.nixos-hardware + "/common/cpu/intel/haswell")
    ];

  services = {
    minecraft-servers.servers = {
      test = {
        enable = false;
        enableReload = true;
        openFirewall = true;
        package = pkgs.vanillaServers.vanilla-1_21_1;
        serverProperties = {
          difficulty = "normal";
          enforce-secure-profile = false;
          motd = "Server managed my pandora";
          online-mode = false;
          server-port = 25565;
        };
        jvmOpts = "-Xms1G -Xmx4G";
      };
    };

    tailscale = {
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--advertise-exit-node"
        "--advertise-routes \"10.0.0.10/32\""
      ];
    };

    ddns-updater.enable = true;
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;
}
