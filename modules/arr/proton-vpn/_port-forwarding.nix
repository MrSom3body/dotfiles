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

                # Delete the old rules from the NixOS firewall
                if [[ -n "$OLD_PORT" ]]; then
                  nft delete rule inet nixos-fw input-allow iifname "${vpnInterface}" tcp dport "$OLD_PORT" accept 2>/dev/null || true
                  nft delete rule inet nixos-fw input-allow iifname "${vpnInterface}" udp dport "$OLD_PORT" accept 2>/dev/null || true
                fi

                # Insert the new rules directly into the NixOS firewall's allow list
                nft insert rule inet nixos-fw input-allow iifname "${vpnInterface}" tcp dport "$PORT" accept
                nft insert rule inet nixos-fw input-allow iifname "${vpnInterface}" udp dport "$PORT" accept

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
