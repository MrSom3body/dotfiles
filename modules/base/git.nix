{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.homeManager = {
    programs = {
      git = {
        enable = true;

        settings = {
          user = { inherit (meta.users.karun) name email; };

          alias =
            let
              log = "log --notes='*' --graph --pretty=format:'%C(auto)%h%Creset%C(auto)% d%Creset %s %Cgreen(%ah) %C(bold blue)<%an>%Creset'";
            in
            {
              a = "add";
              ap = "add --patch";

              b = "branch";
              ba = "branch --all";
              bd = "branch --delete";
              bdd = "branch -D";

              c = "commit";
              ca = "commit --amend";
              cm = "commit -m";

              sw = "switch";
              swc = "switch --create";
              rt = "restore";
              rtp = "restore --patch";

              d = "diff";
              ds = "diff --staged";

              h = "show";
              h1 = "show HEAD~1";
              h2 = "show HEAD~2";
              h3 = "show HEAD~3";
              h4 = "show HEAD~4";
              h5 = "show HEAD~5";

              l = log;
              la = "${log} --all";
              lp = "${log} --patch";

              p = "push";
              pf = "push --force-with-lease";
              pt = "push --tags";

              pl = "pull";

              r = "rebase";
              ra = "rebase --abort";
              rc = "rebase --continue";
              ri = "rebase --interactive";

              rs = "reset";
              rsh = "reset --hard";

              s = "status --short";
              ss = "status";

              t = "tag";

              st = "stash";
              stc = "stash clear";
              sth = "stash show --patch";
              stl = "stash list";
              stp = "stash pop";

              forgor = "commit --amend --no-edit";
            };

          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          rebase.autoStash = true;
        };

        signing = {
          format = "openpgp";
          inherit (meta.users.karun) key;
          signByDefault = true;
        };
      };

      delta = {
        enable = true;
        enableGitIntegration = true;
      };
      fish.shellAbbrs = {

      };
    };
  };
}
