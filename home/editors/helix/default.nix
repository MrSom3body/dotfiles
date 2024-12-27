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
        default-yank-register = "+";
        line-number = "relative";
        cursorline = true;
        auto-format = true;
        completion-replace = true;
        rulers = [80];
        bufferline = "multiple";
        color-modes = true;
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        indent-guides.render = true;
      };
    };
  };
}
