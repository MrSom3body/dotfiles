{
  pkgs,
  settings,
  ...
}: {
  home.packages = with pkgs; [
    fuzzel-goodies
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        placeholder = "Type to search...";
        prompt = "'❯ '";
        icon-theme = "Papirus";
        launch-prefix = "uwsm app --";
        match-counter = true;
        terminal = "${settings.programs.terminal} -e";
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 15;
      };

      border = {
        width = settings.appearance.border.size;
        inherit (settings.appearance.border) radius;
      };
    };
  };
}
