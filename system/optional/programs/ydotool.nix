{ config, ... }:
{
  programs.ydotool = {
    enable = true;
  };

  users.users.karun.extraGroups = [ config.programs.ydotool.group ];
}
