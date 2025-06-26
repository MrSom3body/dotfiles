{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;
  inherit (lib) types;
  cfg = config.my.services.solaar;
in {
  options.my.services.solaar = {
    enable = mkEnableOption "Solaar support";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.solaar;
      defaultText = lib.literalExpression "pkgs.solaar";
      description = "Solaar package to use";
    };

    window = mkOption {
      type = types.enum ["show" "hide" "only"];
      default = "hide";
      description = "Start with window showing / hidden / only (no tray icon)";
    };

    batteryIcons = mkOption {
      type = types.enum ["regular" "symbolic" "solaar"];
      default = "regular";
      description = "Prefer regular battery/symbolic battery/solaar icons";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["--restart-on-wake-up"];
      description = "Extra arguments to pass to Solaar";
    };

    rules = mkOption {
      type = types.str;
      default = "";
      description = "The solaar rules you want to add";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    home.file.".config/solaar/rules.yaml" = mkIf (cfg.rules != "") {
      text = cfg.rules;
    };

    systemd.user.services.solaar = {
      Install.WantedBy = ["graphical-session.target"];

      Unit = {
        Description = "Linux devices manager for the Logitech Unifying Receiver";
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = lib.concatStringsSep " " ([
            "${cfg.package}/bin/solaar"
            "--window"
            cfg.window
            "--battery-icons"
            cfg.batteryIcons
          ]
          ++ cfg.extraArgs);
        Restart = "on-failure";
      };
    };
  };
}
