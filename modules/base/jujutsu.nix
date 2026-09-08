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

        ui.default-command = "log";
      };
    };
  };
}
