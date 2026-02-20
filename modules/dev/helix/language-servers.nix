{
  self,
  config,
  inputs,
  ...
}:
let
  inherit (config) flake;
in
{
  flake.modules.homeManager.dev =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    {
      sops.secrets = lib.mkIf (flake.lib.isInstall config) {
        "language-tool/username" = { };
        "language-tool/api-key" = { };
      };

      home.packages = [ pkgs.typstyle ]; # for formatting typst

      programs.helix.languages.language-server = {
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
        ltex-ls-plus.command = lib.getExe' pkgs.ltex-ls-plus "ltex-ls-plus";
        markdown-oxide.command = lib.getExe pkgs.markdown-oxide;
        nixd = {
          command = lib.getExe pkgs.nixd;
          config.nixd = {
            formatting.command = [
              (lib.getExe pkgs.nixfmt)
              "--strict"
            ];
            options =
              let
                flake = "(builtins.getFlake (toString ${self}))";
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
        rumdl.command = lib.getExe pkgs.rumdl;
        sqls.command = lib.getExe pkgs.sqls;
        superhtml.command = lib.getExe pkgs.superhtml;
        taplo.command = lib.getExe pkgs.taplo;
        terraform-ls.command = lib.getExe pkgs.terraform-ls;
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
        ty.command = lib.getExe pkgs.ty;
        typescript-language-server.command = lib.getExe pkgs.typescript-language-server;
        vscode-css-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
        vscode-html-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
        vscode-json-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
        wakatime.command =
          lib.getExe
            inputs.wakatime-ls.packages.${pkgs.stdenv.hostPlatform.system}.wakatime-ls;
        yaml-language-server.command = lib.getExe pkgs.yaml-language-server;
      };
    };
}
