{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  inherit (lib) types;
  inherit (lib) literalExpression;

  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;
  cfg = config.my.browsers.zen-browser;
in {
  options.my.browsers.zen-browser = {
    enable = mkEnableOption "the zen browser";
    package = mkOption {
      type = types.package;
      default = inputs.zen-browser.packages.${pkgs.system}.zen-browser;
      defaultText = literalExpression "inputs.zen-browser.packages.${pkgs.system}.default";
      description = "zen package to use";
    };
    default = mkOption {
      type = types.bool;
      default = false;
      description = "set zen as the default browser";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
