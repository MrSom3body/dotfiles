{
  flake.modules.nixos.oracle-keep-alive = { pkgs, ... }: {
    systemd.services."oracle-keep-alive" = {
      description = "Sustained load to prevent Oracle Cloud reclamation";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.procps
        pkgs.gawk
      ];

      script = ''
        STRESS_PID=""

        while true; do
          total=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
          available=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
          used_pct=$(( 100 - (available * 100 / total) ))

          # Check if our specific stress-ng process is running
          if [ -n "$STRESS_PID" ] && kill -0 "$STRESS_PID" 2>/dev/null; then
            # Our stress-ng is running and taking ~25% RAM.
            # Kill it only if total usage > 45% (meaning your apps are using > 20% naturally).
            if [ "$used_pct" -gt 45 ]; then
              echo "Total memory usage is $used_pct%. Stopping our stress-ng because apps need RAM..."
              kill "$STRESS_PID"
              STRESS_PID=""
            fi
          else
            # Our stress-ng is not running (reset PID just in case it died externally)
            STRESS_PID=""

            # Start it if natural memory usage drops below 20%.
            if [ "$used_pct" -lt 20 ]; then
              echo "Memory usage is $used_pct% (below 20%). Starting stress-ng padding..."
              ${pkgs.stress-ng}/bin/stress-ng --vm 1 --vm-bytes 25% --vm-hang 0 &
              STRESS_PID=$!
            fi
          fi

          sleep 60
        done
      '';

      serviceConfig = {
        # Ensure it doesn't slow down your actual services
        Nice = 19;
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";

        # Soft memory cap: kernel reclaims from this cgroup first under pressure
        MemoryHigh = "25%";

        Restart = "always";
        RestartSec = "10s";
      };
    };
  };
}
