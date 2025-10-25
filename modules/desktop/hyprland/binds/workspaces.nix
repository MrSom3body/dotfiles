{
  flake.modules.homeManager.desktop = {
    wayland.windowManager.hyprland.settings.bindd = [
      # Special workspaces
      "SUPER, A, Toggle special workspace, togglespecialworkspace, magic"
      "SUPER SHIFT, A, Move focused window to special workspace, movetoworkspace, special:magic"

      "SUPER, S, Toggle Spotify workspace, togglespecialworkspace, spotify"
      "SUPER SHIFT, S, Move focused window to Spotify workspace, movetoworkspace, special:spotify"
      "SUPER, M, Toggle Monitor workspace, togglespecialworkspace, monitor"
      "SUPER SHIFT, M, Move focused window to Monitor workspace, movetoworkspace, special:monitor"
      "SUPER, X, Toggle Discord workspace, togglespecialworkspace, discord"
      "SUPER SHIFT, X, Move focused window to Discord workspace, movetoworkspace, special:discord"
      "SUPER, T, Toggle todoist workspace, togglespecialworkspace, todoist"
      "SUPER SHIFT, T, Move focused window to todoist workspace, movetoworkspace, special:todoist"

      # Switch workspaces
      "SUPER, Prior, Switch to next workspace, workspace, r-1"
      "SUPER, Next, Switch to previous workspace, workspace, r+1"

      "SUPER, mouse_down, Switch to next workspace, workspace, e+1"
      "SUPER, mouse_up, Switch to previous workspace, workspace, e-1"
    ]
    ++ (builtins.concatLists (
      builtins.genList (
        i:
        let
          ws = i + 1;
        in
        [
          "SUPER, code:1${toString i}, Switch to workspace ${toString ws}, workspace, ${toString ws}"
          "SUPER SHIFT, code:1${toString i}, Move focused window to workspace ${toString ws}, movetoworkspace, ${toString ws}"
        ]
      ) 9
    ));
  };
}
