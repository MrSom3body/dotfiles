{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./languages.nix
  ];

  programs.helix = {
    enable = true;

    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-format = true;
        completion-replace = false;
        rulers = [80];
        bufferline = "multiple";
        color-modes = true;

        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "error";

        lsp.display-inlay-hints = true;

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        indent-guides.render = true;
      };

      keys.normal.space = {
        e = [
          ":sh rm -f /tmp/helix-yazi"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/helix-yazi"
          ":insert-output echo \"\x1b[?1049h\x1b[?2004h\" > /dev/tty"
          ":open %sh{cat /tmp/helix-yazi}"
          ":redraw"
        ];
      };
    };

    ignores = [
      "!.github/"
      "!.gitignore"
      "!.gitattributes"
    ];
  };
}
