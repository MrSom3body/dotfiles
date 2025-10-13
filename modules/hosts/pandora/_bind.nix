{
  flake.modules.nixos.bind =
    { pkgs, ... }:
    {
      services.bind = {
        enable = true;
        ipv4Only = true;
        zones."sndh.dev" = {
          allowQuery = [ "100.0.0.0/8" ];
          master = true;
          file = pkgs.writeText "sndh.dev" ''
            $ORIGIN   sndh.dev.
            $TTL      1h
            @         IN  SOA    pandora hostmaster (
                                         1    ; Serial
                                         3h   ; Refresh
                                         1h   ; Retry
                                         1w   ; Expire
                                         1h   ; Negative Cache TTL
                                      )
                      IN  NS     pandora

            @         IN  CNAME  home

            blackbox  IN  A      100.85.36.18
            pandora   IN  A      100.79.165.46
          '';
        };
      };
    };
}
