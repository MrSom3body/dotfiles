{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      settings.bindd =
        let
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
          "SUPER, A, Activate applications submap, submap, applications"
          # Open applications
          "SUPER, RETURN, Open terminal, exec, ${terminal}"
          "SUPER, E, Open terminal terminal file manager, exec, uwsm app -- xdg-terminal-exec ${meta.programs.terminalFileManager}"
          ", XF86Calculator, Open calculator, exec, ${runOnce "gnome-calculator"}"

          # Vesktop
          "CTRL SHIFT, M, Mute on vesktop, pass, class:^(vesktop)$"
          "CTRL SHIFT, D, Deafen on vesktop, pass, class:^(vesktop)$"
        ];

      submaps.applications = {
        onDispatch = "reset";
        settings = {
          bindd = [
            # Open applications
            ", B, Open browser, exec, uwsm app -- ${meta.programs.browser}"
            ", E, Open file manager, exec, uwsm app -- ${meta.programs.fileManager}"
            ", N, Open notes, exec, uwsm app -- obsidian"

            # Scratchpads
            ", M, Toggle monitor workspace, togglespecialworkspace, monitor"
            ", T, Toggle todo workspace, togglespecialworkspace, todo"
            ", S, Toggle Spotify workspace, togglespecialworkspace, spotify"
            ", D, Toggle Discord workspace, togglespecialworkspace, discord"
          ];

          bindr = [ ", catchall, submap, reset" ];
        };

        settings.workspace =
          let
            gaps = "50";
          in
          [
            "special:spotify, on-created-empty:uwsm app -- spotify"
            "special:spotify, gapsout:${gaps}"

            "special:monitor, on-created-empty:uwsm app -- xdg-terminal-exec btop"
            "special:monitor, gapsout:${gaps}"

            "special:discord, on-created-empty:uwsm app -- vesktop"
            "special:discord, gapsout:${gaps}"

            "special:todo, on-created-empty:uwsm app -- lunatask"
            "special:todo, gapsout:${gaps}"
          ];
      };
    };
  };
}
