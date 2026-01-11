{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.todoist-electron ];

      xdg.autostart.entries = [
        "${pkgs.todoist-electron}/share/applications/todoist.desktop"
      ];
    };
}
