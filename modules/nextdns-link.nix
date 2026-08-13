{
  flake.modules.nixos.nextdns-link = { config, pkgs, ... }: {
    sops.secrets.nextdns-link-url.sopsFile = ../secrets/${config.networking.hostName}/nextdns.yaml;

    systemd = {
      services.nextdns-link = {
        description = "Update NextDNS linked IP";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "nextdns-link" ''
            exec ${pkgs.curl}/bin/curl -sf "$(cat ${config.sops.secrets.nextdns-link-url.path})"
          '';
        };
      };

      timers.nextdns-link = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1min";
          OnUnitActiveSec = "5min";
        };
      };
    };
  };
}
