{pkgs, ...}: {
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
    ];
    functions = {
      fish_greeting = "macchina";
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
