{...}: {
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      # wifi.powersave = true;
    };
    nameservers = [
      "45.90.28.0#5781e6.dns.nextdns.io"
      "2a07:a8c0::#5781e6.dns.nextdns.io"
      "45.90.30.0#5781e6.dns.nextdns.io"
      "2a07:a8c1::#5781e6.dns.nextdns.io"
    ];
  };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };

    # DNS resolver
    resolved = {
      enable = true;
      dnsovertls = "true";
    };
  };
}
