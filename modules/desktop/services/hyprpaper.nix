{ lib, ... }:
{
  flake.modules.homeManager.desktop =
    { config, ... }:
    {
      services.hyprpaper = {
        enable = true;
        # TODO remove when https://github.com/nix-community/stylix/pull/2087 gets merged
        settings.wallpaper = lib.mkForce (
          lib.singleton {
            monitor = "";
            path = toString config.stylix.image;
          }
        );
      };
    };
}
