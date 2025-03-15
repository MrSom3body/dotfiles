{pkgs, ...}: {
  imports = [
    ../../system/profiles/server.nix
    ./hardware-configuration.nix

    ../../system/services/minecraft.nix
    ../../system/services/openssh.nix
    ../../system/services/tailscale.nix
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
          motd = "Server managed my SigmaDesk";
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
        "--exit-node-allow-lan-access"
      ];
    };

    ddns-updater.enable = true;
  };
  security.tpm2.enable = true;
  powerManagement.enable = true;
}
