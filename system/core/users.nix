{
  pkgs,
  settings,
  ...
}: {
  users.users.${settings.user} = {
    isNormalUser = true;
    description = settings.username;
    shell = pkgs.fish;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "wireshark"
    ];
  };
}
