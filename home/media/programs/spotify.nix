{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.media;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  options.my.media.spotify = {
    enable = mkEnableOption "the spotify program";
  };

  config = mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
        enabledExtensions = builtins.attrValues {
          inherit (spicePkgs.extensions)
            adblock
            betterGenres
            # keyboardShortcuts
            volumePercentage
            ;
        };
        enabledCustomApps = builtins.attrValues {
          inherit (spicePkgs.apps)
            lyricsPlus
            ncsVisualizer
            ;
        };
      };
  };
}
