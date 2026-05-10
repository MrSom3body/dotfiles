{
  flake.modules.homeManager.hyprland =
    { lib, pkgs, ... }:
    {
      home = {
        packages = [ pkgs.grimblast ];

        sessionVariables = {
          GRIMBLAST_EDITOR = "satty --filename";
        };
      };

      programs.satty = {
        enable = true;
        settings.general = {
          fullscreen = true;
          early-exit = true;
          copy-command = lib.getExe' pkgs.wl-clipboard "wl-copy";
        };
      };
    };
}
