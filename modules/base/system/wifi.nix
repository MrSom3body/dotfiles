{
  flake.modules.nixos.nixos = { pkgs, ... }: {
    networking = {
      networkmanager.wifi = {
        backend = "iwd"; # iwd or wpa_supplicant (default)
        macAddress = "random";
        powersave = true;
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
          Scan = {
            DisablePeriodicScan = false;
            DisableRoamingScan = false;
          };

          DriverQuirks.DefaultInterface = ""; # https://github.com/NixOS/nixpkgs/issues/454655
        };
      };
    };

    environment.systemPackages = [ pkgs.impala ];
  };
}
