{
  flake.modules.nixos.nixos = { pkgs, ... }: {
    networking = {
      domain = "sndh.dev";

      nftables.enable = true;

      useNetworkd = true;
      networkmanager = {
        enable = false;
        dns = "systemd-resolved";
        wifi = {
          backend = "iwd"; # iwd or wpa_supplicant (default)
          macAddress = "random";
          powersave = true;
        };
      };

      wireless.iwd = {
        enable = true;
        settings = {
          Settings.AutoConnect = true;

          General = {
            # NOTE: networkmanager cannot control iwd address randomisation
            AddressRandomization = "network";
            AddressRandomizationRange = "full";

            ManagementFrameProtection = 1;

            RoamRetryInterval = 15;
          };

          DriverQuirks.DefaultInterface = ""; # https://github.com/NixOS/nixpkgs/issues/454655
        };
      };

      nameservers = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "2620:fe::fe#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"
      ];
    };

    services = {
      # DNS resolver
      resolved = {
        enable = true;
        settings.Resolve.DNSOverTLS = "opportunistic";
      };

      # network discovery, mDNS
      avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          domain = true;
          userServices = true;
        };
      };
    };

    environment.systemPackages = [ pkgs.impala ];
  };
}
