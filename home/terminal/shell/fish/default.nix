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
      highscore = "history | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 10";
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
