{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      bindd =
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
          # Open applications
          "SUPER, RETURN, Open terminal, exec, ${terminal}"
          "SUPER, B, Open browser, exec, uwsm app -- ${meta.programs.browser}"
          "SUPER, E, Open terminal terminal file manager, exec, uwsm app -- xdg-terminal-exec ${meta.programs.terminalFileManager}"
          "SUPER SHIFT, E, Open file manager, exec, uwsm app -- ${meta.programs.fileManager}"
          ", XF86Calculator, Open calculator, exec, ${runOnce "gnome-calculator"}"

          "SUPER, N, Open notes, exec, uwsm app -- obsidian"

          # Vesktop
          "CTRL SHIFT, M, Mute on vesktop, pass, class:^(vesktop)$"
          "CTRL SHIFT, D, Deafen on vesktop, pass, class:^(vesktop)$"
        ];
    };
  };
}
