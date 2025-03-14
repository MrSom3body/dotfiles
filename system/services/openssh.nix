{settings, ...}: {
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
    };
  };

  users.users.${settings.user}.openssh.authorizedKeys.keys = settings.authorizedSshKeys;
}
