{
  flake.modules.nixos.oracle-keep-alive =
    { pkgs, ... }:
    {
      systemd.services."oracle-keep-alive" = {
        description = "Sustained load to prevent Oracle Cloud reclamation";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          # 'simple' keeps the process running constantly
          Type = "simple";

          # Use stress-ng to maintain exactly 25% CPU load across all cores
          # and lock 25% of RAM
          ExecStart = ''
            ${pkgs.stress-ng}/bin/stress-ng \
              --cpu 0 \
              --cpu-load 25 \
              --vm 1 \
              --vm-bytes 25% \
              --vm-keep
          '';

          # Ensure it doesn't slow down your actual services
          Nice = 19;
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";

          Restart = "always";
          RestartSec = "10s";
        };
      };
    };
}
