{pkgs, ...}: {
  home.packages = with pkgs; [
    solaar
  ];
  home.file.".config/solaar/rules.yaml" = {
    text = ''
      %YAML 1.3
      ---
      - MouseGesture: Mouse Right
      - Execute: [hyprctl, dispatch, workspace, r+1]
      ...
      ---
      - MouseGesture: Mouse Left
      - Execute: [hyprctl, dispatch, workspace, r-1]
      ...
      ---
      - MouseGesture: [Mouse Down, Mouse Right]
      - Execute: hyprlock
      ...
    '';
  };
}
