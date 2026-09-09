{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.homeManager = {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = { inherit (meta.users.karun) name email; };

        git = {
          sign-on-push = true;
        };

        signing = {
          backend = "gpg";
          inherit (meta.users.karun) key;
        };

        ui = {
          default-command = "log";
          diff-editor = ":builtin";
        };

        aliases = {
          n = [ "new" ];
          l = [
            "log"
            "-r"
            "ancestors(reachable(@, mutable()), 2)"
          ];
        };
      };
    };
  };
}
