{
  self,
  pkgs,
  dotfiles,
  ...
}: {
  home.packages = [
    self.packages.${pkgs.system}.fuzzel-goodies
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
        terminal = "${dotfiles.programs.terminal} -e";
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 15;
      };

      border = {
        width = dotfiles.appearance.border.size;
        inherit (dotfiles.appearance.border) radius;
      };
    };
  };
}
