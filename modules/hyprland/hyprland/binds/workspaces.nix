{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.bindd = [
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
