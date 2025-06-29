{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.comma;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.my.programs.comma = {
    enable = mkEnableOption "the comma program";
  };

  config = mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
