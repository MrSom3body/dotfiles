{settings, ...}: {
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
    };
  };

  users.users = {
    root.openssh.authorizedKeys.keys = settings.authorizedSshKeys;
    karun.openssh.authorizedKeys.keys = settings.authorizedSshKeys;
  };
}
