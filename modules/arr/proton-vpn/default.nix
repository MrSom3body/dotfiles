{
  flake.modules.nixos.arrr =
    { config, ... }:
    let
      active = "de-834";
      wgSecret = field: {
        key = "protonvpn/${active}/${field}";
        sopsFile = ../../../secrets/protonvpn.yaml;
      };
    in
    {
      imports = [
        (import ./_port-forwarding.nix {
          vpnInterface = "protonvpn";
          requiredService = "wg-quick-protonvpn.service";
        })
      ];

      sops = {
        secrets = {
          wg-private-key = wgSecret "private-key";
          wg-public-key = wgSecret "public-key";
          wg-endpoint = wgSecret "endpoint";
        };

        templates."protonvpn.conf".content = ''
          [Interface]
          PrivateKey = ${config.sops.placeholder.wg-private-key}
          Address = 10.2.0.2/32
          Table = off
          PostUp = ip route add 10.2.0.1/32 dev %i
          PostUp = ip rule add from 10.2.0.2 lookup 51820
          PostUp = ip route add default dev %i table 51820
          PreDown = ip rule del from 10.2.0.2 lookup 51820

          [Peer]
          PublicKey = ${config.sops.placeholder.wg-public-key}
          AllowedIPs = 0.0.0.0/0, ::/0
          Endpoint = ${config.sops.placeholder.wg-endpoint}:51820
          PersistentKeepalive = 25
        '';
      };

      networking.wg-quick.interfaces.protonvpn.configFile = config.sops.templates."protonvpn.conf".path;
    };
}
