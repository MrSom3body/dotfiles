{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.eza;
in
{
  options.my.terminal.programs.eza = {
    enable = mkEnableOption "the eza program";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--smart-group"
        "--hyperlink"
      ];
    };
  };
}
