{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.hyprland = { lib, ... }: {
    wayland.windowManager.hyprland = {
      settings.bind =
        let
          lua = lib.generators.mkLuaInline;
          shorten = s: builtins.substring 0 14 s;
          runOnce =
            program:
            let
              prog = shorten program;
            in
            "pgrep ${prog} || uwsm app -- ${program}";

          terminal =
            if meta.programs.terminal == "ghostty" then
              "ghostty +new-window"
            else
              "uwsm app -- ${meta.programs.terminal}";
        in
        [
          {
            _args = [
              "SUPER + A"
              (lua ''hl.dsp.submap("applications")'')
              { description = "Activate applications submap"; }
            ];
          }
          {
            _args = [
              "SUPER + RETURN"
              (lua ''hl.dsp.exec_cmd("${terminal}")'')
              { description = "Open terminal"; }
            ];
          }
          {
            _args = [
              "SUPER + E"
              (lua ''hl.dsp.exec_cmd("uwsm app -- xdg-terminal-exec ${meta.programs.terminalFileManager}")'')
              { description = "Open terminal file manager"; }
            ];
          }
          {
            _args = [
              "XF86Calculator"
              (lua ''hl.dsp.exec_cmd("${runOnce "qalculate-gtk"}")'')
              { description = "Open calculator"; }
            ];
          }

          # Vesktop
          {
            _args = [
              "CTRL + SHIFT + M"
              (lua ''hl.dsp.pass({ window = "class:^(vesktop)$" })'')
              { description = "Mute on vesktop"; }
            ];
          }
          {
            _args = [
              "CTRL + SHIFT + D"
              (lua ''hl.dsp.pass({ window = "class:^(vesktop)$" })'')
              { description = "Deafen on vesktop"; }
            ];
          }
        ];

      submaps.applications = {
        onDispatch = "reset";
        settings.bind =
          let
            lua = lib.generators.mkLuaInline;
          in
          [
            {
              _args = [
                "B"
                (lua ''hl.dsp.exec_cmd("uwsm app -- ${meta.programs.browser}")'')
                { description = "Open browser"; }
              ];
            }
            {
              _args = [
                "E"
                (lua ''hl.dsp.exec_cmd("uwsm app -- ${meta.programs.fileManager}")'')
                { description = "Open file manager"; }
              ];
            }
            {
              _args = [
                "C"
                (lua ''hl.dsp.exec_cmd("uwsm app -- xdg-terminal-exec ikhal")'')
                { description = "Open calendar"; }
              ];
            }
            {
              _args = [
                "N"
                (lua ''hl.dsp.exec_cmd("uwsm app -- obsidian")'')
                { description = "Open notes"; }
              ];
            }

            # Scratchpads
            {
              _args = [
                "M"
                (lua ''hl.dsp.workspace.toggle_special("monitor")'')
                { description = "Toggle monitor workspace"; }
              ];
            }
            {
              _args = [
                "T"
                (lua ''hl.dsp.workspace.toggle_special("todo")'')
                { description = "Toggle todo workspace"; }
              ];
            }
            {
              _args = [
                "S"
                (lua ''hl.dsp.workspace.toggle_special("spotify")'')
                { description = "Toggle Spotify workspace"; }
              ];
            }
            {
              _args = [
                "D"
                (lua ''hl.dsp.workspace.toggle_special("discord")'')
                { description = "Toggle Discord workspace"; }
              ];
            }

            {
              _args = [
                "catchall"
                (lua ''hl.dsp.submap("reset")'')
                { release = true; }
              ];
            }
          ];
      };

      settings.workspace_rule =
        let
          gaps = "50";
        in
        [
          {
            workspace = "special:spotify";
            on_created_empty = "uwsm app -- spotify";
            gaps_out = gaps;
          }
          {
            workspace = "special:monitor";
            on_created_empty = "uwsm app -- xdg-terminal-exec btop";
            gaps_out = gaps;
          }
          {
            workspace = "special:discord";
            on_created_empty = "uwsm app -- vesktop";
            gaps_out = gaps;
          }
          {
            workspace = "special:todo";
            on_created_empty = "uwsm app -- lunatask";
            gaps_out = gaps;
          }
        ];
    };
  };
}
