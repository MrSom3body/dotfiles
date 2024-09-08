{...}: {
  imports = [
    ./languages.nix
  ];

  programs.helix = {
    enable = true;

    settings = {
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-format = true;
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
