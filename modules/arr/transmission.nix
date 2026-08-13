{
  flake.modules.nixos.arr = {
    services = {
      transmission = {
        group = "arr";
        settings = {
          bind-address-ipv4 = "10.2.0.2";
          bind-address-ipv6 = "::1";
          download-dir = "/media/torrents";
          incomplete-dir = "/media/torrents/.incomplete";
          incomplete-dir-enabled = true;
        };
      };
    };
  };
}
