{ lib, inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      services.hyprpaper = {
        enable = true;

        package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
