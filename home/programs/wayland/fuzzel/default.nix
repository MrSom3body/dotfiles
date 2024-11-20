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

  home.file."bin" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
