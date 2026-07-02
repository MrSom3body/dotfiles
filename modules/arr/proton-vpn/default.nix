{
  flake.modules.nixos.arr =
    { config, ... }:
    let
      active = "de-834";
      secret = "protonvpn-wg-${active}";
    in
    {
      imports = [
        (import ./_port-forwarding.nix {
          vpnInterface = "protonvpn";
          requiredService = "wg-quick-protonvpn.service";
        })
      ];

      sops.secrets.${secret}.sopsFile = ../../../secrets/protonvpn.yaml;

      networking.wg-quick.interfaces.protonvpn.configFile = config.sops.secrets.${secret}.path;
    };
}
