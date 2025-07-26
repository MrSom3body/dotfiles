{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) types;
  inherit (lib) literalExpression;

  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;
  cfg = config.my.browsers.firefox;

  defaults = import ./firefoxDefaults.nix { inherit pkgs; };
in
{
  options.my.browsers.firefox = {
    enable = mkEnableOption "the firefox browser";
    package = mkOption {
      type = types.package;
      default = pkgs.firefox-beta-bin;
      defaultText = literalExpression "pkgs.firefox-beta-bin";
      description = "firefox package to use";
    };
    default = lib.mkOption {
      type = types.bool;
      default = false;
      description = "set firefox as the default browser";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = mkIf cfg.default {
      BROWSER = cfg.package.meta.mainProgram;
    };

    programs.firefox = {
      enable = true;
      inherit (cfg) package;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = defaults.settings // {
          "sidebar.verticalTabs" = true;
        };

        inherit (defaults) search;
      };
    };
  };
}
