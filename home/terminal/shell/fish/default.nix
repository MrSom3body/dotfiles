{
  pkgs,
  settings,
  ...
}: {
  programs.fish = {
    enable = true;

    interactiveShellInit =
      # fish
      ''
        fish_vi_key_bindings
        set fish_cursor_default block blink # normal mode
        set fish_cursor_insert line blink # insert mode
        set fish_cursor_replace_one underscore blink # replace mode
        set fish_cursor_replace underscore blink # replace mode
        set fish_cursor_visual block # visual mode

        set fish_cursor_external line # in commands
      '';

    plugins = let
      fishPlugin = name: {
        name = name.pname;
        inherit (name) src;
      };
    in [
      (fishPlugin pkgs.fishPlugins.autopair)
      (fishPlugin pkgs.fishPlugins.done)
      (fishPlugin pkgs.fishPlugins.fzf-fish)
    ];

    functions = {
      fish_greeting = "gotcha";

      highscore = {
        body = "history | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 10";
        description = "See your most used fish commands";
      };
    };

    shellAbbrs = {
      d = "cd ${settings.path}";

      l = "ls";
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -la";

      mkdev = {
        setCursor = "%";
        expansion = "nix flake new --template $NH_FLAKE#%";
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
      gds = "git diff --staged";
      gf = "git commit --amend --no-edit";
      gg = "git log --all --decorate --graph --oneline";
      gl = "git log --oneline";
      gll = "git log";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpl = "git pull";
      gpt = "git push --tags";
      gr = "git rebase";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
      gri = {
        setCursor = "%";
        expansion = "git rebase -i HEAD~%";
      };
      gs = "git status --short";
      gss = "git status --short";
      gsw = "git switch";
      gt = "git tag";
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
