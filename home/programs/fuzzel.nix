{
  lib,
  config,
  inputs,
  pkgs,
  settings,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;

  cfg = config.my.programs.fuzzel;
in
{
  options.my.programs.fuzzel = {
    enable = mkEnableOption "the fuzzel launcher";
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.som3pkgs.packages.${pkgs.system}.fuzzel-goodies ];

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          placeholder = "Type to search...";
          prompt = "'❯ '";
          launch-prefix = "uwsm app --";
          match-counter = true;
          terminal = "xdg-terminal-exec";
          horizontal-pad = 40;
          vertical-pad = 20;
          inner-pad = 15;
          image-size-ratio = 0.3;
        };

        border =
          let
            borderCfg = settings.appearance.border;
          in
          {
            width = borderCfg.size;
            inherit (borderCfg) radius;
            selection-radius = borderCfg.radius;
          };
      };
    };
  };
}
