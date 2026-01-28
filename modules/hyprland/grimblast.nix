{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
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
        };
      };
    };
}
