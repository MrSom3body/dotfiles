{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) types;

  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;
  cfg = config.my.browsers.zen-browser;

  defaults = import ./firefoxDefaults.nix { inherit pkgs; };
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.my.browsers.zen-browser = {
    enable = mkEnableOption "the zen browser";
    default = mkOption {
      type = types.bool;
      default = false;
      description = "set zen as the default browser";
    };
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = mkIf cfg.default {
        BROWSER = "zen";
      };
    };

    programs.zen-browser = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        inherit (defaults) settings search;
      };
    };
  };
}
