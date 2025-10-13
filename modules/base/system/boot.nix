{ lib, ... }:
let
  inherit (lib) mkIf;
in
{
  flake.modules.nixos.base =
    {
      config,
      pkgs,
      hostConfig,
      ...
    }:
    {
      boot = {
        initrd = mkIf hostConfig.isInstall {
          systemd.enable = true;
        };

        kernelPackages = pkgs.linuxPackages_latest;

        consoleLogLevel = 3;
        kernelParams = [
          "quiet"
          "systemd.show_status=auto"
          "rd.udev.log_level=3"
          "preempt=full"
        ];

        # systemd-boot on UEFI
        loader = mkIf hostConfig.isInstall {
          systemd-boot = {
            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.
            enable = !(config.boot.lanzaboote.enable or false);
            configurationLimit = 10;
          };
          efi.canTouchEfiVariables = true;
        };

        plymouth.enable = true;
      };
    };
}
