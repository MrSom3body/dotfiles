{
  config,
  settings,
  ...
}: {
  programs.git = {
    enable = true;

    delta = {
      enable = true;
    };

    aliases = {
      a = "add";
      b = "branch";
      c = "commit";
      ca = "commit --amend";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      ds = "diff --staged";
      l = "log --oneline";
      ll = "log";
      p = "push";
      pf = "push --force-with-lease";
      pl = "pull";
      r = "rebase";
      s = "status --short";
      ss = "status";
      sw = "switch";
      forgor = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      oops = "checkout --";
    };

    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };

    userName = settings.programs.git.username;
    userEmail = settings.programs.git.mail;
  };
}
