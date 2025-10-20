{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.dev =
    { config, ... }:
    {
      programs = {
        git = {
          enable = true;

          settings = {
            user = {
              inherit (meta.users.karun) name;
              inherit (meta.users.karun) email;
            };

            alias = {
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

            init.defaultBranch = "main";
            pull.rebase = true;
            push.autoSetupRemote = true;
            rebase.autoStash = true;
          };

          signing = {
            format = "ssh";
            key = "${config.home.homeDirectory}/.ssh/id_ed25519";
            signByDefault = true;
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
        };
      };
    };
}
