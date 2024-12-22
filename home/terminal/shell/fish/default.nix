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

      ip = {
        body = "ip -c";
        wraps = "ip";
      };

      icat = {
        body = "${pkgs.libsixel}/bin/img2sixel";
        wraps = "img2sixel";
        description = "View Images in your terminal.";
      };
    };

    shellAbbrs = {
      l = "ls";
      la = {
        setCursor = "%";
        expansion = "ls -a%";
      };
      ll = {
        setCursor = "%";
        expansion = "ls -l%";
      };

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
      gds = "git diff -S";
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
