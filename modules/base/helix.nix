{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.helix ];
        programs.nano.enable = false; # eww
      };

    homeManager.homeManager =
      { osConfig, pkgs, ... }:
      {
        programs.helix = {
          enable = true;
          package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix;

          settings = {
            editor = {
              line-number = "relative";
              cursorline = true;
              auto-format = true;
              completion-replace = true;
              rulers = [ 80 ];
              bufferline = "multiple";
              color-modes = true;
              trim-trailing-whitespace = true;
              trim-final-newlines = true;
              rainbow-brackets = true;
              soft-wrap.enable = true;

              end-of-line-diagnostics = "hint";
              inline-diagnostics.cursor-line = "error";

              lsp.display-inlay-hints = true;

              cursor-shape = {
                normal = "block";
                insert = "bar";
                select = "underline";
              };

              word-completion.trigger-length = 4;

              indent-guides.render = true;
            };

            # keys.normal.space = {
            #   e = [
            #     ":sh rm -f /tmp/helix-yazi"
            #     '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/helix-yazi''
            #     ":insert-output echo '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
            #     ":open %sh{cat /tmp/helix-yazi}"
            #     ":redraw"
            #     ":set mouse false"
            #     ":set mouse true"
            #   ];
            # };
          };

          languages = {
            language-server = {
              bash-language-server.command = lib.getExe pkgs.bash-language-server;
              fish-lsp.command = lib.getExe pkgs.fish-lsp;
              nixd = {
                command = lib.getExe pkgs.nixd;
                config.nixd = {
                  formatting.command = [ (lib.getExe pkgs.nixfmt) ];
                  options =
                    let
                      flake = ''(builtins.getFlake "${self}")'';
                      nixos-expr = "${flake}.nixosConfigurations.${osConfig.networking.hostName}.options";
                    in
                    {
                      nixos.expr = nixos-expr;
                      home-manager.expr = "${nixos-expr}.home-manager.users.type.getSubOptions []";
                    };
                };
              };
            };

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
                name = "nix";
                auto-format = true;
                language-servers = [ "nixd" ];
              }

            ];
          };

          ignores = [
            "!.github/"
            "!.gitignore"
            "!.gitattributes"
          ];
        };
      };
  };
}
