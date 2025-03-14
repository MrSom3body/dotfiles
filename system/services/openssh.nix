{settings, ...}: {
  services.openssh = {
    enable = true;
    settings.UseDns = true;
  };

  users.users.${settings.user}.openssh.authorizedKeys.keys = settings.authorizedSshKeys;
}
