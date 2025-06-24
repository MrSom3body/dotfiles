{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.games;
in {
  imports = [
    ./ludusavi.nix
    ./mangohud.nix
  ];

  options.my.games = {
    enable = mkEnableOption "gaming related programs";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        goverlay
        heroic
        mindustry-wayland
        modrinth-app
        r2modman
        ;
    };
  };
}
