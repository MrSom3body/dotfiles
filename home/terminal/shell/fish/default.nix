{pkgs, ...}: {
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; let
      fishPlugin = name: {
        name = name.pname;
        inherit (name) src;
      };
    in [
      (fishPlugin autopair)
      (fishPlugin done)
      (fishPlugin fzf-fish)
    ];
    functions = {
      fish_greeting = "macchina";
      highscore = {
        body = "history | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 10";
        description = "See your most used fish commands.";
      };
    };
  };

  home.file = {
    ".config/fish/functions" = {
      source = ./configs/functions;
      recursive = true;
    };
    ".config/fish/completions" = {
      source = ./configs/completions;
      recursive = true;
    };
  };
}
