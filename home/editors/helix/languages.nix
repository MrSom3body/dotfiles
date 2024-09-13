{
  lib,
  pkgs,
  dotfiles,
  ...
}: {
  programs.helix.languages = {
    language-server = {
      bash-language-server = {
        command = lib.getExe pkgs.bash-language-server;
      };

      marksman = {
        command = lib.getExe pkgs.marksman;
      };

      nil = {
        command = lib.getExe pkgs.nil;
        config.nil = {
          formatting = {
            command = ["${lib.getExe pkgs.alejandra}"];
          };
          nix = {
            flake = {
              autoArchive = true;
              autoEvalInputs = true;
              nixpkgsInputName = "nixpkgs";
            };
          };
        };
      };

      nixd = {
        command = lib.getExe pkgs.nixd;
        config.nixd = {
          formatting = lib.getExe pkgs.alejandra;
          options = {
            nixos = {expr = "(builtins.getFlake \"${dotfiles.path}\").nixosConfigurations.${dotfiles.hostname}.options";};
            home-manager = {expr = "(builtins.getFlake \"${dotfiles.path}\").homeManagerConfigurations.\"${dotfiles.username}\".options";};
          };
        };
      };

      basedpyright = {
        command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
        args = ["--stdio"];
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-languageserver";
      };

      vscode-html-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-languageserver";
      };

      vscode-json-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-languageserver";
      };
    };

    language = [
      {
        name = "bash";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.shfmt;
          args = ["-i" "2"];
        };
      }
      {
        name = "markdown";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "markdown"];
        };
      }
      {
        name = "nix";
        auto-format = true;
        language-servers = ["nil"];
      }
      {
        name = "python";
        language-servers = ["basedpyright"];
        formatter = {
          command = lib.getExe pkgs.ruff;
          args = ["format"];
        };
      }
    ];
  };
}
