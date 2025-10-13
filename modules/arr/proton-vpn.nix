{
  flake.modules.nixos.arr =
    { config, pkgs, ... }:
    {
      networking.wg-quick.interfaces.protonvpn.configFile = "/etc/nixos/files/wireguard/protonvpn.conf";

      sops.secrets.transmission-password.sopsFile = ../../secrets/pandora/secrets.yaml;

      systemd.services.proton-transmission =
        let
          requiredServices = [
            "wg-quick-protonvpn.service"
            "transmission.service"
          ];
        in
        {
          description = "ProtonVPN Port-Forwarding";
          requires = requiredServices;
          after = requiredServices;
          wantedBy = [ "multi-user.target" ];
          path = builtins.attrValues {
            inherit (pkgs)
              iptables
              libnatpmp
              ripgrep
              transmission_4
              ;
          };
          serviceConfig = {
            Restart = "on-failure";
            RestartSec = 5;
            ExecStart =
              let
                outPath = "/tmp/transmission-proton";
              in
              pkgs.writeShellScript "protonvpn-port-forwarding" ''
                OLD_PORT=""
                while true; do
                  date
                  natpmpc -a 1 0 udp 60 -g 10.2.0.1 && natpmpc -a 1 0 tcp 60 -g 10.2.0.1 > ${outPath} || {
                    echo -e "ERROR with natpmpc command \a"
                    break
                  }
                  PORT=$(rg "Mapped public port (\d+)" -or '$1' ${outPath})
                  iptables -I INPUT -p tcp --dport "$PORT" -s 10.2.0.0/24 -j ACCEPT
                  TR_AUTH=":$(cat ${config.sops.secrets.transmission-password.path})" transmission-remote localhost --port $PORT --authenv --no-portmap

                  if [[ -n "$PORT" && "$PORT" != "$OLD_PORT" ]]; then
                    echo "Allowing port $PORT via iptables"

                    if [[ -n "$OLD_PORT" ]]; then
                      iptables -D INPUT -p tcp --dport "$OLD_PORT" -i protonvpn -j ACCEPT || true
                      iptables -D INPUT -p udp --dport "$OLD_PORT" -i protonvpn -j ACCEPT || true
                    fi

                    iptables -I INPUT -p tcp --dport "$PORT" -i protonvpn -j ACCEPT
                    iptables -I INPUT -p udp --dport "$PORT" -i protonvpn -j ACCEPT
                    OLD_PORT="$PORT"

                    # Set transmission port
                    TR_AUTH=":$(cat ${config.sops.secrets.transmission-password.path})" transmission-remote localhost --port "$PORT" --authenv --no-portmap
                  fi

                  sleep 45
                done
              '';
          };
        };
    };
}
