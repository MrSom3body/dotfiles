{
  networking = {
    domain = "sndh.dev";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      # wifi.powersave = true;
    };
    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
  };

  # DNS resolver
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
  };
}
