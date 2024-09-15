{
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      # wifi.powersave = true;
    };
    nameservers = [
      "9.9.9.9#dns.quad9.net"
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
