{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.gotcha;
in {
  options.my.programs.gotcha = {
    enable = mkEnableOption "the objectively best fetch on the world";
  };

  config = mkIf cfg.enable {
    home.packages = [inputs.gotcha.packages.${pkgs.system}.default];
  };
}
