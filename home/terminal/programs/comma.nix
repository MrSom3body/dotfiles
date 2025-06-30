{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.comma;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.my.terminal.programs.comma = {
    enable = mkEnableOption "the comma program";
  };

  config = mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
