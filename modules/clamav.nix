{
  # mostly copied from https://github.com/khaneliman/khanelinix/blob/517f13346ca869bb9879ebe6ff263ee1bd68e8e4/modules/nixos/security/clamav/default.nix
  flake.modules.nixos.clamav =
    { pkgs, lib, ... }:
    let
      excludedDirectories = [
        # Version control & cache
        "(^|/)\\.cache($|/)"
        "(^|/)\\.git($|/)"
        "(^|/)\\.hg($|/)"
        "(^|/)\\.svn($|/)"
        "(^|/)\\.Trash-[0-9]+($|/)"

        # Development environments & build artifacts
        "(^|/)\\.direnv($|/)"
        "(^|/)\\.venv($|/)"
        "(^|/)node_modules($|/)"
        "(^|/)result(-.*)?($|/)"

        # Gaming (huge binaries, managed by launchers)
        "^/home/karun/Games($|/)"
        "^/home/karun/\\.local/share/Steam($|/)"
        "^/home/karun/\\.steam($|/)"

        # Virtualization, Containers, & AI Models (huge opaque files/overlays)
        "^/home/karun/\\.local/share/containers($|/)"
        "^/var/lib/containers($|/)"
        "^/var/lib/libvirt/images($|/)"
        "^/var/lib/private/ollama($|/)"
      ];
      scanDirectories = [
        "/home"
        "/var/lib"
        "/tmp"
        "/var/log"
        "/var/tmp"
      ];

      # Single source of truth for the scan. Used as the scheduled service's
      # ExecStart *and* exposed on PATH as `clamav-fullscan`, so you can force a
      # run on battery (which the unit's ConditionACPower would otherwise skip):
      #   sudo clamav-fullscan            # full scan of the default roots
      #   sudo clamav-fullscan /some/path # scan specific path(s) instead
      fullscan = pkgs.writeShellApplication {
        name = "clamav-fullscan";
        runtimeInputs = [
          pkgs.clamav
          pkgs.systemd
        ];
        text = ''
          echo "Waking up ClamAV daemon (clamd) and loading database..."
          clamdscan --ping 30:2

          if [ "$#" -gt 0 ]; then
            targets=("$@")
          else
            targets=(${lib.concatStringsSep " " scanDirectories})
          fi

          echo "Starting multi-threaded scan..."
          set +e
          clamdscan --multiscan --fdpass "''${targets[@]}"
          exit_code=$?
          set -e

          # If run manually (not via systemd), stop the daemon afterwards to free RAM
          if [ -z "''${INVOCATION_ID:-}" ]; then
            echo "Stopping ClamAV daemon..."
            systemctl stop clamav-daemon.service
          fi

          exit "$exit_code"
        '';
      };
    in
    {
      services.clamav = {
        daemon.enable = true;
        daemon.settings = {
          ExcludePath = excludedDirectories;
          CrossFilesystems = false;
        };
        scanner.enable = false;
        updater.enable = true;
      };

      environment.systemPackages = [ fullscan ];

      # Disable starting the daemon automatically at boot
      systemd.services.clamav-daemon.wantedBy = lib.mkForce [ ];
      # Prevent systemd from deleting /run/clamav (and the socket file) when the daemon stops
      systemd.services.clamav-daemon.serviceConfig.RuntimeDirectoryPreserve = "yes";

      systemd.services.clamav-scan = {
        description = "Scheduled ClamAV scan";
        after = [ "clamav-freshclam.service" ];
        unitConfig.ConditionACPower = true;
        serviceConfig = {
          Type = "oneshot";
          Nice = 19;
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          RuntimeMaxSec = "6h";
          SuccessExitStatus = [ 1 ];

          # The scanner parses untrusted file contents as root; contain it.
          # ProtectHome stays off (scans /home) and ProtectSystem stays at
          # "full" so /tmp remains writable for archive extraction.
          CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateNetwork = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "full";
          RestrictAddressFamilies = [ "AF_UNIX" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          ExecStart = lib.getExe fullscan;
          # Ensure the daemon is shut down after the service exits (success or failure)
          ExecStopPost = "${pkgs.systemd}/bin/systemctl stop clamav-daemon.service";
        };
      };

      systemd.timers.clamav-scan = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "1h";
          Unit = "clamav-scan.service";
        };
      };
    };
}
