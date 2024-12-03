{
  lib,
  pkgs,
  dotfiles,
  ...
}: {
  programs.helix.languages = {
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
        name = "css";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "css"];
        };
      }

      {
        name = "git-commit";
        language-servers = ["ltex"];
      }

      {
        name = "go";
        auto-format = true;
      }

      {
        name = "html";
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "html"];
        };
      }

      {
        name = "markdown";
        auto-format = true;
        soft-wrap.enable = true;
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "markdown"];
        };
        language-servers = ["marksman" "ltex"];
      }

      {
        name = "nix";
        auto-format = true;
        language-servers = ["nixd"];
      }

      {
        name = "python";
        language-servers = ["basedpyright" "ruff"];
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.ruff;
          args = ["format" "--line-length=80" "-"];
        };
      }
    ];

    language-server = {
      basedpyright = {
        command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
        args = ["--stdio"];
      };

      bash-language-server = {
        command = lib.getExe pkgs.bash-language-server;
      };

      golangci-lint = {
        command = lib.getExe pkgs.golangci-lint;
      };

      gopls = {
        command = lib.getExe pkgs.gopls;
      };

      ltex = {
        command = "${pkgs.ltex-ls}/bin/ltex-ls";
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
          nixpkgs.expr = "import (builtins.getFlake \"${dotfiles.path}\").inputs.nixpkgs { }";
          formatting.command = ["${lib.getExe pkgs.alejandra}"];
          options.nixos.expr = "(builtins.getFlake \"${dotfiles.path}\").nixosConfigurations.${dotfiles.hostname}.options";
        };
      };

      ruff = {
        command = lib.getExe pkgs.ruff;
      };

      superhtml = {
        command = lib.getExe pkgs.superhtml;
      };

      taplo = {
        command = lib.getExe pkgs.taplo;
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
      };

      vscode-html-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server";
      };

      vscode-json-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server";
      };

      qmlls = {
        command = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
        args = ["-E"];
      };
    };
  };
}
