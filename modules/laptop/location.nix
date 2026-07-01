{ lib, ... }: {
  flake.modules = {
    nixos.laptop =
      { config, ... }:
      let
        usingWpaSupplicant = config.networking.networkmanager.wifi.backend == "wpa_supplicant";
      in
      lib.mkMerge [
        (lib.mkIf usingWpaSupplicant {
          # geoclue2 only works accurately with wpa_supplicant :/
          location.provider = "geoclue2";
          services.geoclue2 = {
            enable = true;
            geoProviderUrl = "https://beacondb.net/v1/geolocate";
            submissionUrl = "https://beacondb.net/v2/geosubmit";
            submissionNick = "geoclue";
          };

          # automatic timezone using geoclue2
          services.automatic-timezoned.enable = true;
        })

        (lib.mkIf (!usingWpaSupplicant) {
          # automatic timezone using IP
          services.tzupdate.enable = true;
        })
      ];
  };
}
