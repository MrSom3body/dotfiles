{ lib, ... }:
{
  flake.modules.nixos.gaming =
    { config, pkgs, ... }:
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

              programs = lib.makeBinPath (
                (builtins.attrValues {
                  inherit (pkgs)
                    coreutils
                    power-profiles-daemon
                    systemd
                    libnotify
                    ;
                })
                ++ [
                  config.programs.hyprland.package
                ]
              );

              init-script = # bash
                ''
                  export PATH=$PATH:${programs}
                  export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /run/user/1000/hypr | tail -1)
                '';
              start-script = pkgs.writeShellScript "gamemode-start" ''
                ${init-script}
                hyprctl getoption input:kb_options -j | ${lib.getExe pkgs.jq} ".str" -r > $XDG_RUNTIME_DIR/hypr-kb-options
                hyprctl keyword input:kb_options ""
                ${notify "Game Mode enabled!"}
              '';
              end-script = pkgs.writeShellScript "gamemode-end" ''
                ${init-script}
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
    };
}
