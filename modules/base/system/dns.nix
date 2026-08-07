{
  flake.modules.nixos.nixos = {
    networking = {
      nameservers = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "2620:fe::fe#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"
      ];
    };

    services.resolved = {
      enable = true;
      settings.Resolve.DNSOverTLS = "opportunistic";
    };
  };
}
