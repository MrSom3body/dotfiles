{ config, inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = [ inputs.self.packages.${pkgs.system}.fuzzel-goodies ];

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
              borderCfg = config.flake.meta.appearance.border;
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
