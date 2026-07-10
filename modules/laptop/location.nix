{ lib, ... }: {
  flake.modules = {
    nixos.laptop = { pkgs, ... }: {
      # unlock imperative timezone management so timedatectl can write to /etc/localtime
      time.timeZone = lib.mkForce null;

      # Trigger timezone update instantly when the network becomes routable
      services.networkd-dispatcher = {
        enable = true;
        rules."tzupdate" = {
          onState = [ "routable" ];
          script = ''
            #!${pkgs.runtimeShell}
            TZ=$(${lib.getExe pkgs.tzupdate} -p)
            CURRENT_TZ=$(${lib.getExe' pkgs.systemd "timedatectl"} show --property=Timezone --value)

            if [ -n "$TZ" ] && [ "$TZ" != "$CURRENT_TZ" ]; then
              ${lib.getExe' pkgs.systemd "timedatectl"} set-timezone "$TZ"
              ${lib.getExe' pkgs.procps "pkill"} -9 waybar || true
            fi
          '';
        };
      };
    };
  };
}
