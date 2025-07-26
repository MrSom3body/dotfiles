let
  portRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
in {
  networking.firewall = {
    allowedTCPPortRanges = portRanges;
    allowedUDPPortRanges = portRanges;
  };
}
