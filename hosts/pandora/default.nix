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

    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.0.0-20250228175314-1fb64108d4de"];
        hash = "sha256-3nvVGW+ZHLxQxc1VCc/oTzCLZPBKgw4mhn+O3IoyiSs=";
      };
      environmentFile = "/run/secrets/caddy";
      extraConfig = ''
        (cloudflare) {
          tls {
            dns cloudflare {$CF_TOKEN}
          }
        }
      '';

      virtualHosts = {
        "loxone.home.sndh.dev" = {
          extraConfig = ''
            reverse_proxy http://10.0.0.10
            import cloudflare
          '';
        };
      };
    };

    ddns-updater.enable = true;
  };

  security.tpm2.enable = true;
  powerManagement.enable = true;

  sops.secrets.caddy.sopsFile = ../../secrets/pandora/secrets.yaml;
}
