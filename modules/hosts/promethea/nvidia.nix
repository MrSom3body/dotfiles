{
  flake.modules.nixos."hosts/promethea" =
    { config, pkgs, ... }:
    {
      # TODO remove when https://github.com/NixOS/nixpkgs/pull/440422 gets merged
      systemd.services = {
        nvidia-suspend-then-hibernate =
          let
            state = "suspend-then-hibernate";
          in
          {
            description = "NVIDIA system ${state} actions";
            path = [ pkgs.kbd ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = ''${config.hardware.nvidia.package.out}/bin/nvidia-sleep.sh "suspend"'';
            };
            before = [ "systemd-${state}.service" ];
            requiredBy = [ "systemd-${state}.service" ];
          };

        nvidia-resume = {
          after = [ "systemd-suspend-then-hibernate.service" ];
          requiredBy = [ "systemd-suspend-then-hibernate.service" ];
        };
      };
    };
}
