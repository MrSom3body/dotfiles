{
  config,
  pkgs,
  ...
}: {
  networking.wg-quick.interfaces.protonvpn.configFile = "/etc/nixos/files/wireguard/protonvpn.conf";

  sops.secrets.transmission-password.sopsFile = ../../../secrets/pandora/secrets.yaml;

  systemd.services.proton-transmission = let
    requiredServices = ["wg-quick-protonvpn.service" "transmission.service"];
  in {
    description = "ProtonVPN Port-Forwarding";
    requires = requiredServices;
    after = requiredServices;
    wantedBy = ["multi-user.target"];
    path = with pkgs; [
      libnatpmp
      ripgrep
      transmission_4
    ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = let
        outPath = "/tmp/transmission-proton";
      in
        pkgs.writeShellScript "protonvpn-port-forwarding" ''
          while true; do
              date
              natpmpc -a 1 0 udp 60 -g 10.2.0.1 && natpmpc -a 1 0 tcp 60 -g 10.2.0.1 > ${outPath} || {
                  echo -e "ERROR with natpmpc command \a"
                  break
              }
              port=$(rg "Mapped public port (\d+)" -or '$1' ${outPath})
              TR_AUTH=":$(cat ${config.sops.secrets.transmission-password.path})" transmission-remote localhost --port $port --authenv --no-portmap
              sleep 45
          done
        '';
    };
  };
}
