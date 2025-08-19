{
  lib,
  pkgs,
  ...
}:
{
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 15;
        softrealtime = "auto";
      };
      custom =
        let
          notify = title: "${lib.getExe pkgs.libnotify} -a gamemoded -u critical -t 3000 '${title}'";

          start-script = pkgs.writeShellScript "gamemode-start" ''
            hyprctl getoption input:kb_options -j | ${lib.getExe pkgs.jq} ".str" -r > $XDG_RUNTIME_DIR/hypr-kb-options
            hyprctl keyword input:kb_options ""
            ${notify "Game Mode enabled!"}
          '';
          end-script = pkgs.writeShellScript "gamemode-end" ''
            hyprctl keyword input:kb_options $(cat $XDG_RUNTIME_DIR/hypr-kb-options)
            ${notify "Game Mode disabled!"}
          '';
        in
        {
          start = start-script.outPath;
          end = end-script.outPath;
        };
    };
  };

  users.users.karun.extraGroups = [ "gamemode" ];
}
