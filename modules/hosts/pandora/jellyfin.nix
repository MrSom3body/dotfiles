{
  flake.modules.nixos."hosts/pandora" = { pkgs, ... }: {
    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "i965";
    environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";

    hardware.graphics = {
      enable = true;

      extraPackages = with pkgs; [
        intel-ocl # Generic OpenCL support
        intel-vaapi-driver
        libva-vdpau-driver
        intel-compute-runtime-legacy1
      ];
    };

    services.jellyfin = {
      hardwareAcceleration = {
        enable = true;
        type = "vaapi"; # VAAPI is recommended for pre-Broadwell
        device = "/dev/dri/renderD128";
      };
    };
  };
}
