{ inputs, ... }:
{
  flake.modules.nixos."hosts/pandora" =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixos-hardware.nixosModules.common-pc
        (inputs.nixos-hardware + "/common/cpu/intel/haswell")
      ];

      networking.interfaces.eno1.wakeOnLan.enable = true;

      hardware = {
        intelgpu = {
          enableHybridCodec = true;
        };

        graphics.extraPackages = builtins.attrValues {
          inherit (pkgs)
            intel-compute-runtime-legacy1
            intel-media-sdk
            libva-vdpau-driver
            ;
        };
      };

      nixpkgs.config.packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };

      environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
      systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "i965";
      systemd.services.immich.environment.LIBVA_DRIVER_NAME = "i965";
    };
}
