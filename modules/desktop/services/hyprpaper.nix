{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.hyprpaper = {
        enable = true;

        package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    };
}
