{ lib, ... }: {
  flake.modules = {
    nixos.laptop =
      { config, pkgs, ... }:
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
          # unlock imperative timezone management so timedatectl can write to /etc/localtime
          time.timeZone = lib.mkForce null;

          # run tzupdate instantly on network connect, bypassing hourly timers
          networking.networkmanager.dispatcherScripts = [
            {
              source = pkgs.writeShellScript "run-tzupdate" ''
                [ "$2" != "connectivity-change" ] && exit 0

                TZ=$(${lib.getExe pkgs.tzupdate} -p)
                CURRENT_TZ=$(${lib.getExe' pkgs.systemd "timedatectl"} show --property=Timezone --value)

                if [ -n "$TZ" ] && [ "$TZ" != "$CURRENT_TZ" ]; then
                  ${lib.getExe' pkgs.systemd "timedatectl"} set-timezone "$TZ"
                  ${lib.getExe' pkgs.procps "pkill"} -9 waybar || true
                fi
              '';
              type = "basic";
            }
          ];
        })
      ];
  };
}
