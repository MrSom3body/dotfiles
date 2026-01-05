{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.grimblast
          pkgs.satty
        ];

        sessionVariables = {
          GRIMBLAST_EDITOR = "satty --filename";
        };
      };
    };
}
