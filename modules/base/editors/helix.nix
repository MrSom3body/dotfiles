{ inputs, ... }:
{
  flake.modules = {
    nixos.base =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.helix ];
        programs.nano.enable = false; # eww
      };

    homeManager.base =
      { pkgs, ... }:
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

          ignores = [
            "!.github/"
            "!.gitignore"
            "!.gitattributes"
          ];
        };
      };
  };
}
