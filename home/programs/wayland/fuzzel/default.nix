{
  pkgs,
  dotfiles,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        placeholder = "Type to search...";
        prompt = "'❯ '";
        icon-theme = "Papirus";
        launch-prefix = "uwsm app --";
        match-counter = true;
        terminal = "${dotfiles.terminal} -e";
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 15;
      };

      border = {
        width = 3;
        radius = dotfiles.rounding;
      };
    };
  };

  home.packages = with pkgs; [
    jq
  ];

  home.file = {
    "bin/fuzzel-actions" = {
      source = ./scripts/fuzzel-actions.fish;
      executable = true;
    };
    "bin/fuzzel-clipboard" = {
      source = ./scripts/fuzzel-clipboard.fish;
      executable = true;
    };
    "bin/fuzzel-files" = {
      source = ./scripts/fuzzel-files.fish;
      executable = true;
    };
    "bin/fuzzel-icons" = {
      source = ./scripts/fuzzel-icons.fish;
      executable = true;
    };
    "bin/fuzzel-windows" = {
      source = ./scripts/fuzzel-windows.fish;
      executable = true;
    };
  };
}
