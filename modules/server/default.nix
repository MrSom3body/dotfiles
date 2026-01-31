{ lib, ... }:
{
  flake.modules.nixos.server =
    { config, ... }:
    {
      networking = {
        firewall = {
          enable = lib.mkForce true;
          allowedTCPPorts = [
            80
            443
          ];
        };
      };

      # copied from https://github.com/nix-community/srvos/blob/762ba4502de7b2fc6bd044e62fd326b3d220c510/nixos/server/default.nix
      environment = {
        # Print the URL instead on servers
        variables.BROWSER = "echo";
        # Don't install the /lib/ld-linux.so.2 and /lib64/ld-linux-x86-64.so.2
        # stubs. Server users should know what they are doing.
        stub-ld.enable = lib.mkDefault false;
      };

      xdg = {
        autostart.enable = lib.mkDefault false;
        icons.enable = lib.mkDefault false;
        menus.enable = lib.mkDefault false;
        mime.enable = lib.mkDefault false;
        sounds.enable = lib.mkDefault false;
      };

      # Given that our systems are headless, emergency mode is useless.
      # We prefer the system to attempt to continue booting so
      # that we can hopefully still access it remotely.
      boot.initrd.systemd.suppressedUnits = lib.mkIf config.systemd.enableEmergencyMode [
        "emergency.service"
        "emergency.target"
      ];

      systemd = {
        # Given that our systems are headless, emergency mode is useless.
        # We prefer the system to attempt to continue booting so
        # that we can hopefully still access it remotely.
        enableEmergencyMode = false;

        # For more detail, see:
        #   https://0pointer.de/blog/projects/watchdog.html
        settings.Manager = {
          # systemd will send a signal to the hardware watchdog at half
          # the interval defined here, so every 7.5s.
          # If the hardware watchdog does not get a signal for 15s,
          # it will forcefully reboot the system.
          RuntimeWatchdogSec = lib.mkDefault "15s";
          # Forcefully reboot if the final stage of the reboot
          # hangs without progress for more than 30s.
          # For more info, see:
          #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
          RebootWatchdogSec = lib.mkDefault "30s";
          # Forcefully reboot when a host hangs after kexec.
          # This may be the case when the firmware does not support kexec.
          KExecWatchdogSec = lib.mkDefault "1m";
        };

        sleep.extraConfig = ''
          AllowSuspend=no
          AllowHibernation=no
        '';
      };

      virtualisation.vmVariant.virtualisation.graphics = false;
    };
}
