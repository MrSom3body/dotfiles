{ settings, ... }:
{
  imports = [
    ./avahi.nix
  ];

  networking = {
    hostName = settings.hostname;
    domain = "sndh.dev";

    useNetworkd = true;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        macAddress = "random";
        powersave = true;
      };
    };

    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
  };

  users.users.karun.extraGroups = [ "networkmanager" ];

  # DNS resolver
  services.resolved = {
    enable = true;
    dnsovertls = "true";
    dnssec = "true";
  };

  # slows down boot time
  systemd.network.wait-online.enable = false;
  systemd.services = {
    NetworkManager-wait-online.enable = false;

    # use systemctl restart instead of a stop and a delayed start
    systemd-networkd.stopIfChanged = false;
    systemd-resolved.stopIfChanged = false;
  };

}
