{ lib, ... }: {
  flake.modules.nixos.nixos = {
    networking = {
      domain = "sndh.dev";

      nftables.enable = true;
      useDHCP = lib.mkDefault true;

      useNetworkd = true;
      networkmanager = {
        enable = lib.mkDefault false;
        dns = "systemd-resolved";
      };
    };

    services = {
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
  };
}
