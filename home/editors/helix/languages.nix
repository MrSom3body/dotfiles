{
  self,
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.editors.helix;
in {
  imports = [
    ./ai
  ];

  config = mkIf cfg.enable {
    home.packages =
      builtins.attrValues {
        inherit
          (pkgs)
          # docker
          docker-compose-language-service
          # go
          golangci-lint
          gopls
          # html
          superhtml
          # nix
          nixd
          # markdown
          marksman
          # php
          phpactor
          pretty-php
          # python
          ruff
          basedpyright
          # shell
          shfmt
          bash-language-server
          # sql
          sqls
          # toml
          taplo
          # typos
          ltex-ls-plus
          # typst
          tinymist
          typstyle
          # xml
          lemminx
          # yaml
          yaml-language-server
          ;
      }
      ++ builtins.attrValues {
        inherit
          (pkgs.nodePackages)
          # others
          prettier
          vscode-langservers-extracted
          ;
      };

    programs.helix = {
      languages = {
        language = [
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = "shfmt";
              args = ["-i" "2"];
            };
          }

          {
            name = "css";
            auto-format = true;
            formatter = {
              command = "prettier";
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
            auto-format = true;
            formatter = {
              command = "prettier";
              args = ["--parser" "html"];
            };
          }

          {
            name = "markdown";
            auto-format = true;
            soft-wrap.enable = true;
            formatter = {
              command = "prettier";
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
            name = "php";
            auto-format = true;
            formatter.command = "pretty-php";
            language-servers = ["phpactor"];
          }

          {
            name = "python";
            language-servers = ["basedpyright" "ruff" "gpt"];
            auto-format = true;
            formatter = {
              command = "ruff";
              args = ["format" "--line-length=80" "-"];
            };
          }

          {
            name = "sql";
            language-servers = ["sqls"];
          }

          {
            name = "typst";
            auto-format = true;
            language-servers = ["tinymist"];
          }

          {
            name = "xml";
            language-servers = ["lemminx"];
          }
        ];

        language-server = {
          basedpyright = {
            command = "basedpyright-langserver";
            args = ["--stdio"];
          };

          lemminx = {
            command = "lemminx";
          };

          ltex = {
            command = "ltex-ls-plus";
          };

          nixd = {
            config.nixd = {
              formatting.command = ["${lib.getExe pkgs.alejandra}"];
              options = let
                flake = ''(builtins.getFlake "${self}")'';
              in rec {
                nixos.expr = "${flake}.nixosConfigurations.${osConfig.networking.hostName}.options";
                home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions []";
              };
            };
          };

          phpactor = {
            command = "phpactor";
            args = ["language-server"];
          };

          sqls = {
            command = "sqls";
          };

          tinymist = {
            config = {
              exportPdf = "onType";
              outputPath = "$root/target/$dir/$name";

              formatterMode = "typstyle";
              formatterPrintWidth = 80;

              lint = {
                enabled = true;
                when = "onType";
              };
            };
          };
        };
      }; #
    };
  };
}
