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
      config,
      ...
    }:
    {
      sops.secrets = lib.mkIf (flake.lib.isInstall config) {
        "language-tool/username" = { };
        "language-tool/api-key" = { };
      };

      programs.fish.interactiveShellInit = ''
        set -gx LT_USERNAME $(cat ${config.sops.secrets."language-tool/username".path})
        set -gx LT_API_KEY $(cat ${config.sops.secrets."language-tool/api-key".path})
      '';

      programs.helix.languages.language-server = {
        bash-language-server.command = lib.getExe pkgs.bash-language-server;
        codebook = {
          command = lib.getExe pkgs.codebook;
          args = [ "serve" ];
        };
        fish-lsp.command = lib.getExe pkgs.fish-lsp;
        ltex-ls-plus = {
          command = lib.getExe' pkgs.ltex-ls-plus "ltex-ls-plus";
          config.ltex = {
            languageToolHttpServerUri = "https://api.languagetoolplus.com/";
            languageToolOrg = {
              username = "\${LT_USERNAME}";
              apiKey = "\${LT_API_KEY}";
            };
          };
        };
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
        rumdl.command = lib.getExe pkgs.rumdl;
        superhtml.command = lib.getExe pkgs.superhtml;
        taplo.command = lib.getExe pkgs.taplo;
        tinymist.config = {
          exportPdf = "onType";
          outputPath = "$root/target/$dir/$name";
          formatterMode = "typstyle";
          formatterPrintWidth = 80;
          lint = {
            enabled = true;
            when = "onType";
          };
        };
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
