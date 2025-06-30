{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.gotcha;
in {
  options.my.terminal.programs.gotcha = {
    enable = mkEnableOption "the objectively best fetch on the world";
  };

  config = mkIf cfg.enable {
    home.packages = [inputs.gotcha.packages.${pkgs.system}.default];
  };
}
