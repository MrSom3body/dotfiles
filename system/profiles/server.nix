{
  lib,
  config,
  ...
}:
{
  imports = [
    ../global

    ../optional/services/autoUpgrade.nix
    ../optional/services/fail2ban.nix
    ../optional/services/openssh.nix
  ];

  system.autoUpgrade = {
    allowReboot = true;
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
  };

  networking.firewall.enable = lib.mkForce true;

  # Given that our systems are headless, emergency mode is useless.
  # We prefer the system to attempt to continue booting so
  # that we can hopefully still access it remotely.
  boot.initrd.systemd.suppressedUnits = lib.mkIf config.systemd.enableEmergencyMode [
    "emergency.service"
    "emergency.target"
  ];

  # copied from https://github.com/nix-community/srvos/blob/762ba4502de7b2fc6bd044e62fd326b3d220c510/nixos/server/default.nix
  systemd = {
    # Given that our systems are headless, emergency mode is useless.
    # We prefer the system to attempt to continue booting so
    # that we can hopefully still access it remotely.
    enableEmergencyMode = false;

    # For more detail, see:
    #   https://0pointer.de/blog/projects/watchdog.html
    watchdog = {
      # systemd will send a signal to the hardware watchdog at half
      # the interval defined here, so every 7.5s.
      # If the hardware watchdog does not get a signal for 15s,
      # it will forcefully reboot the system.
      runtimeTime = "15s";
      # Forcefully reboot if the final stage of the reboot
      # hangs without progress for more than 30s.
      # For more info, see:
      #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
      rebootTime = "30s";
      # Forcefully reboot when a host hangs after kexec.
      # This may be the case when the firmware does not support kexec.
      kexecTime = "1m";
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };

  virtualisation.vmVariant.virtualisation.graphics = false;
}
