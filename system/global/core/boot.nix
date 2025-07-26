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
  inherit (lib) literalExpression;

  inherit (lib) mkOption;
  inherit (lib) mkEnableOption;

  cfg = config.my.boot;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.my.boot = {
    enable = mkEnableOption "my boot things" // {
      default = true;
    };
    lanzaboote = {
      enable = mkEnableOption "lanzaboote";
      pkiBundle = mkOption {
        type = types.path;
        default = "/etc/secureboot";
        defaultText = literalExpression ''"/etc/secureboot"'';
        description = "Path to a PKI bundle for Secure Boot.";
      };
    };

    isInstall = mkEnableOption "setting options appropriate for installs" // {
      default = true;
    };

    kernel = mkOption {
      type = types.attrs;
      default = pkgs.linuxPackages_latest;
      defaultText = literalExpression "pkgs.linuxPackages_latest";
      description = "kernel package to use";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      initrd = mkIf cfg.isInstall {
        systemd.enable = true;
      };

      kernelPackages = cfg.kernel;

      consoleLogLevel = 3;
      kernelParams = [
        "quiet"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
        "preempt=full"
      ];

      # systemd-boot on UEFI
      loader = mkIf cfg.isInstall {
        systemd-boot = {
          # Lanzaboote currently replaces the systemd-boot module.
          # This setting is usually set to true in configuration.nix
          # generated at installation time. So we force it to false
          # for now.
          enable = !cfg.lanzaboote.enable;
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
      };

      lanzaboote = mkIf cfg.lanzaboote.enable {
        enable = true;
        inherit (cfg.lanzaboote) pkiBundle;
      };

      plymouth.enable = true;
    };

    environment.systemPackages = mkIf cfg.lanzaboote.enable [ pkgs.sbctl ];
  };
}
