{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) types;
  inherit (lib) literalExpression;

  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;
  cfg = config.my.editors.helix;
in
{
  imports = [
    ./languages.nix
  ];

  options.my.editors.helix = {
    enable = mkEnableOption "the helix editor" // {
      default = true;
    };
    package = mkOption {
      type = types.package;
      inherit (inputs.helix.packages.${pkgs.system}) default;
      defaultText = literalExpression "inputs.helix.packages.${pkgs.system}.default";
      description = "helix package to use";
    };
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;

      inherit (cfg) package;

      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          auto-format = true;
          completion-replace = false;
          rulers = [ 80 ];
          bufferline = "multiple";
          color-modes = true;
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
}
