{
  config,
  dotfiles,
  ...
}: let
  cfg = config.programs.git;
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
      p = "push";
      pf = "push --force-with-lease";
      pl = "pull";
      l = "log";
      r = "rebase";
      s = "status --short";
      ss = "status";
      forgor = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      oops = "checkout --";
    };

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };

    extraConfig = {
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = config.home.homeDirectory + "/" + config.xdg.configFile."git/allowed_signers".target;
      };
    };

    userName = dotfiles.name;
    userEmail = dotfiles.email;
  };

  xdg.configFile."git/allowed_signers".text = ''
    ${cfg.userEmail} namespaces="git" ${dotfiles.key}
  '';
}
