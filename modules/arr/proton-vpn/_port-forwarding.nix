{ vpnInterface, requiredService }: { config, pkgs, ... }: {
  sops.secrets.transmission-password.sopsFile = ../../../secrets/transmission.yaml;

  systemd.services.proton-transmission =
    let
      requiredServices = [
        requiredService
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
          coreutils
          nftables
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

              if [[ -n "$PORT" && "$PORT" != "$OLD_PORT" ]]; then
                echo "Allowing port $PORT via nftables"

                # Create table and chain if they don't exist
                nft add table inet proton-vpn-port-forward
                nft add chain inet proton-vpn-port-forward input '{ type filter hook input priority filter - 1; policy accept; }'

                # Flush chain to remove old rules
                nft flush chain inet proton-vpn-port-forward input

                # Add new rules
                nft add rule inet proton-vpn-port-forward input iifname "${vpnInterface}" tcp dport "$PORT" accept
                nft add rule inet proton-vpn-port-forward input iifname "${vpnInterface}" udp dport "$PORT" accept
                
                OLD_PORT="$PORT"

                # Set transmission port
                TR_AUTH=":$(cat ${config.sops.secrets.transmission-password.path})" transmission-remote localhost --port "$PORT" --authenv --no-portmap
              fi

              sleep 45
            done
          '';
      };
    };
}
