{ lib, inputs, ... }:
let
  defaultLanguages = (fromTOML (builtins.readFile "${inputs.helix}/languages.toml")).language;
  getLanguageServers =
    name:
    let
      # find the language in the default config
      lang = lib.findFirst (l: l.name == name) null defaultLanguages;
    in
    if lang != null then lang.language-servers or [ ] else [ ];
in
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    let
      prettier = lang: {
        command = lib.getExe pkgs.prettier;
        args = [
          "--parser"
          lang
        ];
      };

      languages = [
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
          language-servers = [ "ltex-ls-plus" ];
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
            "ltex-ls-plus"
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
            "ty"
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
            "ltex-ls-plus"
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
    in
    {
      programs.helix.languages.language = lib.forEach languages (
        lang:
        lang
        // {
          language-servers = (lang.language-servers or (getLanguageServers lang.name)) ++ [ "wakatime" ];
        }
      );
    };
}
