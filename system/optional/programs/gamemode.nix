{
  lib,
  pkgs,
  ...
}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 6;
        softrealtime = "auto";
      };
      custom = let
        notify = title: "${lib.getExe pkgs.libnotify} -a gamemoded -u critical -t 3000 '${title}'";
      in {
        start = notify "Game Mode enabled!";
        end = notify "Game Mode disabled!";
      };
    };
  };
}
