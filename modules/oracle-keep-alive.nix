{
  flake.modules.nixos.oracle-keep-alive =
    { pkgs, ... }:
    {
      systemd.services."oracle-keep-alive" = {
        description = "Sustained load to prevent Oracle Cloud reclamation";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";

          ExecStart = ''
            ${pkgs.stress-ng}/bin/stress-ng \
              --vm 1 \
              --vm-bytes 25%
          '';

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
