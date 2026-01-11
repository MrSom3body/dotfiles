{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.lunatask ];

      xdg.autostart.entries = [
        "${pkgs.lunatask}/share/applications/lunatask.desktop"
      ];
    };
}
