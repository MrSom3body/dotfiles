{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkOption;
  inherit (lib) mkEnableOption;
  cfg = config.my.boot;
in {
  options.my.boot = {
    enable =
      mkEnableOption "my boot things"
      // {
        default = true;
      };
    isInstall =
      mkEnableOption "setting options appropriate for installs"
      // {
        default = true;
      };
    kernel = mkOption {
      type = lib.types.attrs;
      default = pkgs.linuxPackages_latest;
      defaultText = lib.literalExpression "pkgs.linuxPackages_latest";
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
          enable = true;
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
      };

      plymouth.enable = true;
    };
  };
}
