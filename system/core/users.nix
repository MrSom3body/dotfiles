{
  pkgs,
  dotfiles,
  ...
}: {
  users.users.${dotfiles.user} = {
    isNormalUser = true;
    description = dotfiles.username;
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
