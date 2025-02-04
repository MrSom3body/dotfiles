{config, ...}: let
  cfg = config.programs.git;
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKSJm8M+cxXmYVQMjKYtEMuP3pdYdIJBJzbm3NP/v2q karun@blackbox";
in {
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
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = config.home.homeDirectory + "/" + config.xdg.configFile."git/allowed_signers".target;
      };

      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };

    userName = "Karun Sandhu";
    userEmail = "129101708+MrSom3body@users.noreply.github.com";
  };

  xdg.configFile."git/allowed_signers".text = ''
    ${cfg.userEmail} namespaces="git" ${key}
  '';
}
