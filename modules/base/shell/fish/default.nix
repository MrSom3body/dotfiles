{ lib, inputs, ... }: {
  flake.modules = {
    nixos.nixos = {
      programs.fish.enable = true;
    };

    homeManager.homeManager = { pkgs, ... }: {
      programs.fish = {
        enable = true;

        interactiveShellInit =
          # fish
          ''
            fish_vi_key_bindings
            set fish_cursor_default block blink # normal mode
            set fish_cursor_insert line blink # insert mode
            set fish_cursor_replace_one underscore blink # replace mode
            set fish_cursor_replace underscore blink # replace mode
            set fish_cursor_visual block # visual mode

            set fish_cursor_external line # in commands
          '';

        plugins =
          let
            fishPlugin = name: {
              name = name.pname;
              inherit (name) src;
            };
          in
          [
            (fishPlugin pkgs.fishPlugins.autopair)
            (fishPlugin pkgs.fishPlugins.fzf-fish)
          ];

        functions = {
          fish_greeting = lib.getExe inputs.gotcha.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };

        shellAbbrs = {
          d = "cd ~/dotfiles";

          l = "ls";
          la = "ls -a";
          ll = "ls -l";
          lla = "ls -la";

          mkdev = {
            setCursor = "%";
            expansion = "nix flake new --template $NH_FLAKE#%";
          };

          # Git Stuff
          gti = "git"; # because I can't type
          g = "git";
        };
      };

      home.file = {
        ".config/fish/functions" = {
          source = ./configs/functions;
          recursive = true;
        };
        ".config/fish/completions" = {
          source = ./configs/completions;
          recursive = true;
        };
      };
    };
  };

}
