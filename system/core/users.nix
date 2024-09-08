{
  pkgs,
  dotfiles,
  ...
}: {
  users.users.${dotfiles.username} = {
    isNormalUser = true;
    description = dotfiles.name;
    shell = pkgs.${dotfiles.shell};
    initialPassword = "password";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
  };
}
