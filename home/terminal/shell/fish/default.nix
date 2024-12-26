{
  pkgs,
  dotfiles,
  ...
}: {
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
      fish_greeting = "gotcha";

      highscore = {
        body = "history | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 10";
        description = "See your most used fish commands";
      };
    };

    shellAbbrs = {
      d = "cd ${dotfiles.path}";

      l = "ls";
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -la";

      # Git Stuff
      gti = "git"; # because I can't type
      g = "git";
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gca = "git commit --amend";
      gcm = {
        setCursor = "%";
        expansion = "git commit -m \"%\"";
      };
      gd = "git diff";
      gds = "git diff --staged";
      gf = "git commit --amend --no-edit";
      gg = "git log --all --decorate --graph --oneline";
      gl = "git log --oneline";
      gll = "git log";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpl = "git pull";
      gr = "git rebase";
      gs = "git status --short";
      gss = "git status --short";
      gsw = "git switch";
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
