{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.hyprpaper = {
        enable = true;

        package = inputs.hyprpaper.packages.${pkgs.system}.default;
      };
    };
}
