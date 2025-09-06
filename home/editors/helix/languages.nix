{
  lib,
  config,
  osConfig,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my.editors.helix;
  prettier = lang: {
    command = lib.getExe pkgs.prettier;
    args = [
      "--parser"
      lang
    ];
  };
in
{
  imports = [
    ./ai
  ];

  config = mkIf cfg.enable {
    home.packages = [ pkgs.typstyle ];

    programs.helix = {
      languages = {
        language = [
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.shfmt;
              args = [
                "-i"
                "2"
              ];
            };
          }

          {
            name = "css";
            auto-format = true;
            formatter = prettier "css";
            language-servers = [
              "vscode-css-language-server"
              "codebook"
            ];
          }

          {
            name = "git-commit";
            language-servers = [ "ltex" ];
          }

          {
            name = "go";
            auto-format = true;
            language-servers = [
              "gopls"
              "golangci-lint-langserver"
              "codebook"
            ];
          }

          {
            name = "html";
            auto-format = true;
            formatter = prettier "html";
            language-servers = [
              "vscode-html-language-server"
              "superhtml"
              "codebook"
            ];
          }

          {
            name = "htmldjango";
            auto-format = true;
            file-types = [ { glob = "**/templates/**/*.html"; } ];
            language-servers = [
              "djlsp"
              "vscode-html-language-server"
              "superhtml"
              "codebook"
            ];
          }

          {
            name = "javascript";
            auto-format = true;
            formatter = prettier "typescript";
          }

          {
            name = "json";
            auto-format = true;
            formatter = prettier "json";
          }

          {
            name = "jsonc";
            auto-format = true;
            formatter = prettier "jsonc";
          }

          {
            name = "markdown";
            auto-format = true;
            soft-wrap.enable = true;
            formatter = prettier "markdown";
            language-servers = [
              "marksman"
              "ltex"
            ];
          }

          {
            name = "nix";
            auto-format = true;
            language-servers = [ "nixd" ];
          }

          {
            name = "php";
            auto-format = true;
            formatter.command = lib.getExe pkgs.pretty-php;
            language-servers = [ "phpactor" ];
          }

          {
            name = "python";
            auto-format = true;
            formatter = {
              command = "ruff";
              args = [
                "format"
                "--line-length=80"
                "-"
              ];
            };
            language-servers = [
              "basedpyright"
              "ruff"
              "gpt"
              "codebook"
            ];
          }

          {
            name = "sql";
            language-servers = [ "sqls" ];
          }

          {
            name = "typescript";
            auto-format = true;
            formatter = prettier "typescript";
          }

          {
            name = "tsx";
            auto-format = true;
            formatter = prettier "typescript";
          }

          {
            name = "typst";
            auto-format = true;
            language-servers = [
              "tinymist"
              "ltex"
            ];
          }

          {
            name = "xml";
            language-servers = [ "lemminx" ];
          }

          {
            name = "yaml";
            auto-format = true;
            formatter = prettier "yaml";
          }
        ];

        language-server = {
          basedpyright = {
            command = lib.getExe' pkgs.basedpyright "basedpyright-langserver";
            config.python.analysis.typeCheckingMode = "basic";
          };
          bash-language-server.command = lib.getExe pkgs.bash-language-server;
          codebook = {
            command = lib.getExe pkgs.codebook;
            args = [ "serve" ];
          };
          docker-compose-langserver.command = lib.getExe pkgs.docker-compose-language-service;
          fish-lsp.command = lib.getExe pkgs.fish-lsp;
          golangci-lint-lsp.command = lib.getExe pkgs.golangci-lint-langserver;
          gopls.command = lib.getExe pkgs.gopls;
          lemminx.command = lib.getExe pkgs.lemminx;
          ltex.command = lib.getExe pkgs.ltex-ls-plus;
          marksman.command = lib.getExe pkgs.marksman;
          nixd = {
            command = lib.getExe pkgs.nixd;
            config.nixd = {
              formatting.command = [ (lib.getExe pkgs.nixfmt) ];
              options =
                let
                  flake = ''(builtins.getFlake "${inputs.self}")'';
                  nixos-expr = "${flake}.nixosConfigurations.${osConfig.networking.hostName}.options";
                in
                {
                  nixos.expr = nixos-expr;
                  home-manager.expr = "${nixos-expr}.home-manager.users.type.getSubOptions []";
                };
            };
          };
          phpactor = {
            command = lib.getExe pkgs.phpactor;
            args = [ "language-server" ];
          };
          ruff.command = lib.getExe pkgs.ruff;
          sqls.command = lib.getExe pkgs.sqls;
          superhtml.command = lib.getExe pkgs.superhtml;
          taplo.command = lib.getExe pkgs.taplo;
          tinymist = {
            command = lib.getExe pkgs.tinymist;
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
          typescript-language-server.command = lib.getExe pkgs.typescript-language-server;
          vscode-css-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
          vscode-html-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
          vscode-json-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
          yaml-language-server.command = lib.getExe pkgs.yaml-language-server;
        };
      };
    };
  };
}
