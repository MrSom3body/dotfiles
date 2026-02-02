{ lib, ... }:
{
  # TODO remove when https://github.com/NixOS/nixpkgs/pull/440422 gets merged
  flake.modules.nixos."hosts/promethea" =
    { config, pkgs, ... }:
    let
      nvidia = config.hardware.nvidia.package.out;
    in
    {
      environment.etc."systemd/system-sleep/nvidia".source = pkgs.writeShellScript "nvidia-sleep" ''
        export PATH=${
          lib.makeBinPath [
            pkgs.coreutils
            pkgs.kbd
          ]
        }:$PATH
        exec "${nvidia}/lib/systemd/system-sleep/nvidia" "$@"
      '';

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
              ExecStart = [
                ''${nvidia}/bin/nvidia-sleep.sh "is-suspend-then-hibernate-supported"''
                ''${nvidia}/bin/nvidia-sleep.sh "suspend"''
              ];
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
