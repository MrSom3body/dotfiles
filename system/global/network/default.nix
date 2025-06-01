{
  imports = [
    ./avahi.nix
  ];

  networking = {
    domain = "sndh.dev";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
  };

  users.users.karun.extraGroups = ["networkmanager"];

  # DNS resolver
  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };
}
