{
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      # wifi.powersave = true;
    };
    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112@853#dns.quad9.net"
    ];
  };

  services = {
    openssh = {
      enable = false;
      settings.UseDns = true;
    };

    # DNS resolver
    resolved = {
      enable = true;
      dnsovertls = "true";
    };
  };
}
