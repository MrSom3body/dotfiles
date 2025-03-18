{
  lib,
  config,
  ...
}: {
  sops = {
    secrets.nextdns-id.sopsFile = ../../secrets/global.yaml;
    templates."nextdns-config".content = ''
      report-client-info yes
      profile ${config.sops.placeholder.nextdns-id}
    '';
  };

  services = {
    nextdns = {
      enable = true;
      arguments = [
        "-config-file"
        config.sops.templates.nextdns-config.path
      ];
    };

    resolved.extraConfig = ''
      DNS=127.0.0.1
      DNSStubListener=no
    '';
  };

  networking.nameservers = lib.mkForce [];
}
