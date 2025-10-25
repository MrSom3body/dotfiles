{
  flake.modules.homeManager.desktop = {
    wayland.windowManager.hyprland.settings.bindd =
      let
        shorten = s: builtins.substring 0 14 s;
        toggleScript =
          program: script:
          let
            prog = shorten program;
          in
          "pkill ${prog} || uwsm app -- ${script}";
      in
      [
        "SUPER, V, Show clipboard history, exec, ${toggleScript "fuzzel" "fuzzel-clipboard"}"
        "SUPER CTRL, V, Clear clipboard history, exec, uwsm app -- rm $XDG_CACHE_HOME/cliphist/db"
      ];
  };
}
