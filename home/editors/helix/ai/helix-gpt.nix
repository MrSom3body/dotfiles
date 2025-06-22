{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.editors.helix;
in {
  config = mkIf cfg.enable {
    sops.secrets.copilot-api-key = {};

    programs = {
      helix.languages.language-server.gpt = {
        command = lib.getExe pkgs.helix-gpt;
        args = [
          "--handler"
          "copilot"
        ];
      };

      fish.interactiveShellInit = ''
        set -gx COPILOT_API_KEY $(cat ${config.sops.secrets.copilot-api-key.path})
      '';
    };
  };
}
