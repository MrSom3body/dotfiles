{ config, inputs, ... }:
let
  flakeConfig = config.flake;
in
{
  flake.modules.nixos."hosts/promethea" =
    { config, pkgs, ... }:
    {
      imports = [ inputs.nixos-hardware.nixosModules.asus-zenbook-um6702 ];

      hardware = {
        asus.battery.chargeUpto = 80;
      };

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

      nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ]; # TODO remove https://github.com/NixOS/nixpkgs/issues/437865

      boot.kernelParams = [ "amdgpu.dcdebugmask=0x40000" ];

      services = {
        tailscale.extraSetFlags = [ "--accept-routes" ];
        ollama.acceleration = "cuda";
      };

      specialisation.enable-ollama.configuration = {
        environment.etc."specialisation".text = "enable-ollama"; # for nh
        system.nixos.tags = [ "enable-ollama" ]; # to display it in the boot loader
        imports = [ flakeConfig.modules.nixos.ollama ];
      };

      security.tpm2.enable = true;
    };
}
