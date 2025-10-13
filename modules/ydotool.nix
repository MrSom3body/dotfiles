{
  flake.modules.nixos.ydotool =
    { config, ... }:
    {
      programs.ydotool = {
        enable = true;
      };

      users.users.karun.extraGroups = [ config.programs.ydotool.group ];
    };
}
